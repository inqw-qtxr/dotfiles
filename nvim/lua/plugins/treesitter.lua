return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        -- List of parsers to install
        local ensure_installed = {
            -- Languages
            "lua", "python", "typescript", "javascript", "go", "rust", "c", "cpp",
            "html", "css", "json", "yaml", "tsx",
            "scss", "jsdoc", "prisma", "graphql", "regex",
            -- Ruby
            "ruby", "embedded_template",
            -- Shell and tools
            "bash", "fish", "make", "dockerfile",
            -- Documentation
            "markdown", "markdown_inline",
            -- Git
            "git_rebase", "gitcommit", "gitignore",
            -- Configuration
            "toml", "vim", "regex",
        }

        configs.setup({
            ensure_installed = ensure_installed,
            sync_install = false,
            auto_install = true,
            ignore_install = {},

            highlight = {
                enable = true,
                disable = {},
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
        })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
}

