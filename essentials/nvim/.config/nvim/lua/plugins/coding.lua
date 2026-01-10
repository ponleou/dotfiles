return {
    -- autofill pairs characters
    {
        'nvim-mini/mini.pairs',
        version = '*',
        event = "InsertEnter",
        config = function()
            require('mini.pairs').setup()
        end
    },

    -- adds keybind to generate pairs characters surrounding selection
    {
        'nvim-mini/mini.surround',
        version = '*',
        event = "VeryLazy",
        config = function()
            require('mini.surround').setup()
        end
    },

    -- better comments syntax for languages
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },

    -- autocomplete and suggestions
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = { preset = 'default' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
}
