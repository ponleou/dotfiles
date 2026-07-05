return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"shellcheck",
					"trivy",
					"cpplint",
					"stylelint",
					"htmlhint",
					"eslint_d",
					"jinja-lsp",
					"jsonlint",
					"vale",
					"luacheck",
					"phpcs",
					"ruff",
					"mypy",
					"rubocop",
					"erb-lint",
					"yamllint",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				cs = { "trivy" },
				c = { "cpplint" },
				cpp = { "cpplint" },
				css = { "stylelint" },
				dockerfile = { "trivy" },
				html = { "htmlhint" },
				javascript = { "eslint_d" },
				jinja = { "jinja-lsp" },
				json = { "jsonlint" },
				latex = { "vale" },
				lua = { "luacheck" },
				markdown = { "vale" },
				php = { "phpcs" },
				python = { "mypy", "ruff" },
				ruby = { "rubocop" },
				eruby = { "erb_lint" },
				typescript = { "eslint_d" },
				yaml = { "yamllint" },
			}
		end,
	},
}
