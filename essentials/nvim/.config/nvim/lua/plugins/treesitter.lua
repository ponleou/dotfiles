return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local languages = {
			"bash",
			"c_sharp",
			"c",
			"cpp",
			"css",
			"dockerfile",
			"html",
			"javascript",
			"jsx",
			"jinja",
			"json",
			"latex",
			"lua",
			"markdown",
			"meson",
			"php",
			"python",
			"ruby",
			"tsx",
			"typescript",
			"vue",
			"yaml",
			"zsh",
		}

		require("nvim-treesitter").install(languages)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = languages,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
