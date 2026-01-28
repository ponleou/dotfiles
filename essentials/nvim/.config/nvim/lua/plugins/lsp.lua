return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {       
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
                "mesonlsp",
                "phpactor",
                "pylsp",
                "herb_ls",
                "ruby_lsp",
                "ts_ls",
                "vue_ls",
                "yamlls",
            }
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
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
