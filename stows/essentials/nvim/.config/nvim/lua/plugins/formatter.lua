return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"beautysh",
					"csharpier",
					"clang-format",
					"prettierd",
					"prettier",
					"djlint",
					"latexindent",
					"stylua",
					"php-cs-fixer",
					"black",
					"rubocop",
					"erb-formatter",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				sh = { "beautysh" },
				cs = { "csharpier" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				jinja = { "djlint" },
				json = { "prettierd", "prettier", stop_after_first = true },
				tex = { "latexindent" },
				lua = { "stylua" },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				php = { "php_cs_fixer" },
				python = { "black" },
				ruby = { "rubocop" },
				eruby = { "erb_format" },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				vue = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
			formatters = {
				shfmt = {
					append_args = { "-i", "2" },
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
