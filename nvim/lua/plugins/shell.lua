return {
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "shellcheck") -- Linter for shell scripts
            table.insert(opts.ensure_installed, "shfmt")        -- Formatter for shell scripts
            table.insert(opts.ensure_installed, "bash-language-server") -- LSP for shell scripts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.bashls.setup({
                filetypes = { "sh", "bash", "zsh", "fish" },
            })
        end,
    },
}