return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- LSP
                "solargraph",     -- Main Ruby LSP
                "ruby-lsp",       -- Alternative Ruby LSP
                -- Linters
                "rubocop",        -- Ruby style checker
                "standardrb",     -- Ruby formatter/linter
                -- Debug

                -- Extra tools
                "erb-lint",      -- ERB linter
                "htmlbeautifier", -- ERB formatter
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                solargraph = {
                    cmd = { "solargraph", "stdio" },
                    filetypes = { "ruby", "rakefile" },
                    root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git", "."),
                    init_options = {
                        formatting = false, -- Let standardrb/rubocop handle formatting
                    },
                    settings = {
                        solargraph = {
                            autoformat = false,
                            completion = true,
                            diagnostic = true,
                            folding = true,
                            references = true,
                            rename = true,
                            symbols = true,
                            definitions = true,
                            hover = true,
                            diagnostics = true,
                            useBundler = true, -- Use bundler for better gem support
                        },
                    },
                },
                ruby_ls = {
                    -- Alternative LSP setup
                    cmd = { "ruby-lsp" },
                    filetypes = { "ruby" },
                    init_options = {
                        formatter = "auto",
                    },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "suketa/nvim-dap-ruby", -- Ruby DAP adapter
        },
        config = function()
            local dap = require("dap")
            require("dap-ruby").setup()
            
            -- Rails debugging configuration
            table.insert(dap.configurations.ruby, {
                type = "ruby",
                name = "Rails Server",
                request = "attach",
                localfs = true,
                command = "bundle exec rails server",
                args = {},
                port = 1234,
            })
            
            -- RSpec debugging configuration
            table.insert(dap.configurations.ruby, {
                type = "ruby",
                name = "RSpec - Current File",
                request = "launch",
                program = "bundle",
                programArgs = { "exec", "rspec", "${file}" },
                useBundler = true,
            })
        end,
    },
    {
        "tpope/vim-rails",
        dependencies = { 
            "tpope/vim-bundler",
            "tpope/vim-projectionist",
            "tpope/vim-rake",
        },
        event = { 
            "BufReadPre *.rb",
            "BufNewFile *.rb",
        },
        config = function()
            -- Rails.vim enhancements
            vim.g.rails_projections = {
                ["app/controllers/*_controller.rb"] = {
                    test = {
                        "spec/requests/{}_spec.rb",
                        "spec/controllers/{}_controller_spec.rb",
                    },
                },
                ["app/models/*.rb"] = {
                    test = "spec/models/{}_spec.rb",
                },
                ["app/workers/*.rb"] = {
                    test = "spec/workers/{}_spec.rb",
                },
                ["app/services/*.rb"] = {
                    test = "spec/services/{}_spec.rb",
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "ruby",
                "erb",
                "css",
                "html",
                "javascript",
                "yaml",
            },
        },
    },
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "windwp/nvim-ts-autotag",
        opts = {
            filetypes = {
                "html", "xml", "erb", "embedded_template",
            },
        },
    },
    {
        "slim-template/vim-slim",
        ft = "slim",
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                ruby = { "standardrb", "rubocop" },
                erb = { "htmlbeautifier" },
            },
            formatters = {
                standardrb = {
                    command = "bundle",
                    args = { "exec", "standardrb", "--fix", "-a", "--stdin", "$FILENAME" },
                },
                rubocop = {
                    command = "bundle",
                    args = { "exec", "rubocop", "--auto-correct", "-f", "quiet", "--stdin", "$FILENAME" },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                ruby = { "rubocop" },
                erb = { "erb_lint" },
            },
            linters = {
                rubocop = {
                    command = "bundle",
                    args = { "exec", "rubocop", "--format", "json", "--force-exclusion" },
                },
            },
        },
    },
}