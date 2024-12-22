-- Helper functions for SQL keymaps and commands
local function create_sql_keymaps(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- SQL specific keymaps
    vim.keymap.set("n", "<leader>sq", "<cmd>DBUIToggle<CR>", 
        vim.tbl_extend("force", opts, { desc = "Toggle DBUI" }))
    vim.keymap.set("n", "<leader>sqa", "<cmd>DBUIAddConnection<CR>", 
        vim.tbl_extend("force", opts, { desc = "Add Connection" }))
    vim.keymap.set("n", "<leader>sqf", "<cmd>DBUIFindBuffer<CR>", 
        vim.tbl_extend("force", opts, { desc = "Find Buffer" }))
    vim.keymap.set("n", "<leader>sql", "<cmd>DBUILastBuffer<CR>", 
        vim.tbl_extend("force", opts, { desc = "Last Buffer" }))
end

return {
    -- Database UI and Management
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { 
                "tpope/vim-dadbod",
                lazy = true 
            },
            { 
                "kristijanhusak/vim-dadbod-completion",
                ft = { "sql", "mysql", "plsql", "pgsql" },
                lazy = true 
            },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- UI Configuration
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_force_echo_notifications = 1
            vim.g.db_ui_win_position = 'left'
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. '/db_ui'

            -- Enhanced icons configuration
            vim.g.db_ui_icons = {
                expanded = {
                    db = { icon = "▾", hl = "@dbui.Database.Expanded.Icon" },
                    schema = { icon = "▾", hl = "@dbui.Schema.Expanded.Icon" },
                    table = { icon = "▾", hl = "@dbui.Table.Expanded.Icon" },
                    column = { icon = "▾", hl = "@dbui.Column.Expanded.Icon" },
                },
                collapsed = {
                    db = { icon = "▸", hl = "@dbui.Database.Collapsed.Icon" },
                    schema = { icon = "▸", hl = "@dbui.Schema.Collapsed.Icon" },
                    table = { icon = "▸", hl = "@dbui.Table.Collapsed.Icon" },
                    column = { icon = "▸", hl = "@dbui.Column.Collapsed.Icon" },
                },
                connection = {
                    open = { icon = "󰆼", hl = "@dbui.Connection.Open.Icon" },
                    closed = { icon = "󰿆", hl = "@dbui.Connection.Closed.Icon" },
                },
                default = { icon = "", hl = "@dbui.Default.Icon" },
                table = {
                    kind = {
                        base = { icon = "󰓫", hl = "@dbui.Table.Base.Icon" },
                        view = { icon = "󰨤", hl = "@dbui.Table.View.Icon" },
                        system = { icon = "󱂛", hl = "@dbui.Table.System.Icon" },
                    },
                },
                query = {
                    state = {
                        running = { icon = "󰑮", hl = "@dbui.Query.State.Running.Icon" },
                        cached = { icon = "󰋚", hl = "@dbui.Query.State.Cached.Icon" },
                        unknown = { icon = "󰯡", hl = "@dbui.Query.State.Unknown.Icon" },
                        error = { icon = "󰅚", hl = "@dbui.Query.State.Error.Icon" },
                    },
                },
            }
        end,
        opts = {
            winwidth = 35,
            show_numbers = true,
            show_help = true,
            show_system_tables = false,
            mappings = {
                -- Custom mappings for DBUI window
                toggle_mapped_only = true,
                mappings = {
                    toggle = "<CR>",
                    up = "k",
                    down = "j",
                    left = "h",
                    right = "l",
                    refresh = "R",
                    add_connection = "A",
                    delete_connection = "D",
                    select_connection = "<Space>",
                },
            },
        },
        config = function(_, opts)
            -- Set up completion for SQL files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql", "pgsql" },
                callback = function()
                    require("cmp").setup.buffer({
                        sources = {
                            { name = "vim-dadbod-completion" },
                            { name = "buffer" },
                            { name = "path" },
                        },
                    })
                end,
            })
        end,
    },

    -- SQL Language Server
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            -- Ensure SQL related tools are installed
            local tools = {
                "sqlls",            -- SQL language server
                "sql-formatter",    -- SQL formatter
                "sqlfmt",          -- Alternative SQL formatter
            }
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, tools)
        end,
    },

    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- SQL LSP configuration
            lspconfig.sqlls.setup({
                filetypes = { "sql", "mysql", "pgsql", "plsql" },
                root_dir = function() return vim.loop.cwd() end,
                settings = {
                    sqlLanguageServer = {
                        lint = {
                            enable = true,
                        },
                        format = {
                            enable = true,
                        },
                        diagnostics = {
                            enable = true,
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    -- Setup SQL-specific keymaps
                    create_sql_keymaps(bufnr)

                    -- Enable formatting on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ 
                                async = false,
                                timeout_ms = 2000,
                            })
                        end,
                    })

                    -- Set up SQL specific buffer options
                    vim.bo[bufnr].tabstop = 2
                    vim.bo[bufnr].shiftwidth = 2
                    vim.bo[bufnr].expandtab = true
                    vim.bo[bufnr].commentstring = '-- %s'
                end,
            })
        end,
    },
}