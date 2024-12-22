return {
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod",                        lazy = true },
            { "kristijanhusak/vim-dadbod-completion",    ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Let specific filetypes/plugins start this plugin, not on startup
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_icons = {
                expanded = {
                    db = {
                        icon = "▾",
                        hl = "@dbui.Database.Expanded.Icon",
                    },
                    schema = {
                        icon = "▾",
                        hl = "@dbui.Schema.Expanded.Icon",
                    },
                    table = {
                        icon = "▾",
                        hl = "@dbui.Table.Expanded.Icon",
                    },
                    column = {
                        icon = "▾",
                        hl = "@dbui.Column.Expanded.Icon",
                    },
                },
                collapsed = {
                    db = {
                        icon = "▸",
                        hl = "@dbui.Database.Collapsed.Icon",
                    },
                    schema = {
                        icon = "▸",
                        hl = "@dbui.Schema.Collapsed.Icon",
                    },
                    table = {
                        icon = "▸",
                        hl = "@dbui.Table.Collapsed.Icon",
                    },
                    column = {
                        icon = "▸",
                        hl = "@dbui.Column.Collapsed.Icon",
                    },
                },
                connection = {
                    open = {
                        icon = " ",
                        hl = "@dbui.Connection.Open.Icon",
                    },
                    closed = {
                        icon = " ",
                        hl = "@dbui.Connection.Closed.Icon",
                    },
                },
                default = {
                    icon = "",
                    hl = "@dbui.Default.Icon",
                },
                table = {
                    kind = {
                        base = {
                            icon = "",
                            hl = "@dbui.Table.Base.Icon",
                        },
                        view = {
                            icon = "",
                            hl = "@dbui.Table.View.Icon",
                        },
                        system = {
                            icon = "",
                            hl = "@dbui.Table.System.Icon",
                        },
                    },
                },
                query = {
                    state = {
                        running = {
                            icon = "",
                            hl = "@dbui.Query.State.Running.Icon",
                        },
                        cached = {
                            icon = "",
                            hl = "@dbui.Query.State.Cached.Icon",
                        },
                        unknown = {
                            icon = "",
                            hl = "@dbui.Query.State.Unknown.Icon",
                        },
                        error = {
                            icon = "",
                            hl = "@dbui.Query.State.Error.Icon",
                        },
                    },
                },
            }
        end,
        opts = {
            winwidth = 30,
            show_numbers = true,
            -- mapper function for overriding keymaps in DBUI
            mapper = function(key, default, buffer, dbui_window)
                local normal = function(mapping, opts)
                    vim.keymap.set("n", mapping, default .. key, {
                        buffer = buffer,
                        desc = opts.desc,
                        noremap = true,
                        silent = true,
                    })
                end
                -- these are the defaults, but you can change them to whatever you want
                if key == "<tab>" then
                    normal("<tab>", { desc = "next source" })
                    normal("<s-tab>", { desc = "prev source" })
                elseif key == "<2-LeftMouse>" then
                    normal("<2-LeftMouse>", { desc = "toggle" })
                elseif key == "q" then
                    normal("q", { desc = "close DBUI" })
                elseif key == "<cr>" then
                    normal("<cr>", { desc = "execute" })
                elseif key == "p" then
                    normal("p", { desc = "preview" })
                elseif key == "s" then
                    normal("s", { desc = "split and execute" })
                elseif key == "v" then
                    normal("v", { desc = "vsplit and execute" })
                elseif key == "t" then
                    normal("t", { desc = "tab and execute" })
                end
            end,
        },
        config = function()
            -- Keymaps for DBUI
            vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
            vim.keymap.set("n", "<leader>db+", "<cmd>DBUIAddConnection<CR>", { desc = "Add DB Connection" })
            vim.keymap.set("n", "<leader>dbr", "<cmd>DBUIRefresh<CR>", { desc = "DBUI Refresh" })
            vim.keymap.set("n", "<leader>dbf", "<cmd>DBUIFindBuffer<CR>", { desc = "DBUI Find Buffer" })
            vim.keymap.set("n", "<leader>dbl", "<cmd>DBUILastBuffer<CR>", { desc = "DBUI Last Buffer" })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "sqlls")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.sqlls.setup({
                filetypes = { "sql" },
                settings = {
                    sql = {
                        connections = {}, -- Define your connections here or use :DBUIAddConnection
                    },
                },
            })
        end,
    },
    -- Other SQL related configurations can be added here as needed
}