return {
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
                python = { "ruff" },
                ruby = { "rubocop" },
                eruby = { "erb_lint" },
                typescript = { "eslint_d" },
                yaml = { "yamllint" },
            }
        end,
    },
}
