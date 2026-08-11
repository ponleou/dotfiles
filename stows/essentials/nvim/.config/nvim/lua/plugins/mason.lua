return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- lints
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
					"rubocop",
					"erb-lint",
					"yamllint",
					-- formatters
					"beautysh",
					"csharpier",
					"clang-format",
					"prettierd",
					"prettier",
					"djlint",
					"latexindent",
					"stylua",
					"php-cs-fixer",
					"ruff",
					"rubocop",
					"erb-formatter",
				},
			})
		end,
	},
}
