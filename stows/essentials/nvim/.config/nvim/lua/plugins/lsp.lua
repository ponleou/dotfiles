return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
        config = function()
                vim.lsp.config("ltex_plus", {
      settings = {
        ltex = { language = "en-AU" },
      },
    })
    require("mason-lspconfig").setup({
        ensure_installed = {
				"bashls",
				"csharp_ls",
				"clangd",
				"cssls",
				"docker_language_server",
				"html",
				"jinja_lsp",
				"jsonls",
				"texlab",
				"lua_ls",
				"marksman",
				"ltex_plus",
				"mesonlsp",
				"phpactor",
				"ty",
				"herb_ls",
				"ruby_lsp",
				"ts_ls",
				"vue_ls",
				"yamlls",
			},

    })
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
