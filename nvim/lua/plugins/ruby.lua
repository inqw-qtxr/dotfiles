return {
    -- Ruby/Rails Development

    { "tpope/vim-rails", dependencies = { "tpope/vim-bundler", "tpope/vim-projectionist" } },
    { "RRethy/nvim-treesitter-endwise" },
    { "tpope/vim-rake" },
    { "tpope/vim-bundler" },
    { "slim-template/vim-slim" },

    { "windwp/nvim-ts-autotag" },
    { "MunifTanjim/prettier.nvim" },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "solargraph", -- Ruby LSP
                "rubocop",    -- Ruby linter
                "standardrb", -- Ruby formatter
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.solargraph.setup({
                cmd = { "solargraph", "stdio" },
                filetypes = { "ruby" },
                root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
                settings = {
                    solargraph = {
                        autoformat = true,
                        completion = true,
                        diagnostic = true,
                        folding = true,
                        references = true,
                        rename = true,
                        symbols = true,
                    },
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            table.insert(opts.formatters_by_ft, {
                ruby = { "standardrb", "rubocop" },
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        opts = function(_, opts)
            table.insert(opts.linters_by_ft, {
                ruby = { "rubocop" },
            })
        end,
    },
    -- Add more Ruby/Rails specific configurations as needed
}