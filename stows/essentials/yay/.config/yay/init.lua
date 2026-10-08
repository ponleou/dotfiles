yay.create_autocmd("PostInstall", {
	desc = "clean up caches, while keeping PKGBUILD for diff checks",
	callback = function(event)
		yay.log.info("\027[1m" .. "Running cache clean up and checker" .. "\027[0m")

		-- get all directories in .cache/yay
		local cache_dir = os.getenv("HOME") .. "/.cache/yay"
		local list = io.popen('find "' .. cache_dir .. '" -mindepth 1 -maxdepth 1 -type d')

		-- if the list actually worked
		if not list then
			yay.log.error("could not list " .. cache_dir)
			return
		end

		-- get all foreign packages (which is from aur)
		local installed_not_cached = {}
		local pacman_list = io.popen("pacman -Qmq")
		if pacman_list then
			for pkg in pacman_list:lines() do
				-- package is installed, but doesnt exist in cache (will check later and be set to false if it is cached)
				installed_not_cached[pkg] = true
			end
			pacman_list:close()
		else
			yay.log.error("could not list installed foreign packages")
		end

		local cached_not_installed_list = {}

		for dir in list:lines() do
			-- getting the package name, aka, the folder name of the directory (for logging only)
			local pkgname = dir:match("([^/]+)$")

			if pkgname then
				-- find the git remote url of each directory
				local remote = io.popen('git -C "' .. dir .. '" remote get-url origin 2>/dev/null')
				local origin_url = ""

				-- parse the output of the git remote get-url command, if exists
				if remote then
					origin_url = remote:read("*a"):gsub("%s+$", "")
					remote:close()

					-- if its not from HTTPS aur, then skip
					if not origin_url:match("^https://aur%.archlinux%.org/") then
						yay.log.warn("skipping " .. pkgname .. ", remote is from " .. origin_url)
					else
						-- else, clean the folder to latest git commit (keeping PKGBUILD)
						yay.log.info("resetting yay caches for " .. pkgname)
						os.execute('git -C "' .. dir .. '" checkout -- . >/dev/null 2>&1')
						os.execute('git -C "' .. dir .. '" clean -fdx >/dev/null 2>&1')

						if installed_not_cached[pkgname] then
							-- setting it to false means it is cached
							installed_not_cached[pkgname] = false
						else
							yay.log.warn(pkgname .. " is not installed")
							table.insert(cached_not_installed_list, pkgname)
						end
					end
				else
					-- if git remote url doesn't exist, warn
					yay.log.warn("could not read git remote url for " .. pkgname)
				end
			end
		end
		list:close()

		if #cached_not_installed_list > 0 then
			yay.log.info(
				"\027[1m" .. "Packages not installed: " .. "\027[0m" .. table.concat(cached_not_installed_list, " ")
			)
		end

		local installed_not_cached_list = {}

		for pkg, not_cached in pairs(installed_not_cached) do
			if not_cached then
				table.insert(installed_not_cached_list, pkg)
			end
		end

		if #installed_not_cached_list > 0 then
			yay.log.warn(
				"\027[1m" .. "Packages not cached: " .. "\027[0m" .. table.concat(installed_not_cached_list, " ")
			)
		end
	end,
})
