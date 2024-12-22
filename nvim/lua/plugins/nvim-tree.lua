return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    version = "*", -- Use the latest stable version
    lazy = false,  -- Load during startup
    config = function()
        -- Recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- Set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        -- Empty setup using defaults
        local nvim_tree = require("nvim-tree")
        local api = require("nvim-tree.api")

        -- Enhanced keymaps with silent option
        local function map(mode, lhs, rhs, opts)
            local options = { noremap = true, silent = true }
            if opts then options = vim.tbl_extend("force", options, opts) end
            vim.keymap.set(mode, lhs, rhs, options)
        end

        -- Core keymaps
        map("n", "<leader>E", api.tree.toggle, { desc = "Toggle file explorer" })
        map("n", "<leader>F", api.tree.focus, { desc = "Focus file explorer" })
        map("n", "<leader>ef", api.tree.find_file, { desc = "Find current file in tree" })
        map("n", "<leader>ec", api.tree.collapse_all, { desc = "Collapse file explorer" })
        map("n", "<leader>er", api.tree.reload, { desc = "Refresh file explorer" })

        -- Custom functions
        local function open_nvim_tree(data)
            -- Buffer is a [No Name]
            local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

            -- Buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1

            if not no_name and not directory then
                return
            end

            if directory then
                vim.cmd.cd(data.file)
            end

            -- Open the tree
            api.tree.open()
        end

        -- Auto open tree for directories
        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

        -- Setup nvim-tree with enhanced configuration
        nvim_tree.setup({
            sort_by = "case_sensitive",
            view = {
                width = {
                    min = 30,
                    max = 50,
                    padding = 1,
                },
                side = "left",
                number = false,
                relativenumber = false,
                signcolumn = "yes",
                float = {
                    enable = false,
                    open_win_config = {
                        relative = "editor",
                        border = "rounded",
                        width = 30,
                        height = 30,
                        row = 1,
                        col = 1,
                    },
                },
                adaptive_size = true,
            },
            renderer = {
                group_empty = true,
                highlight_git = true,
                full_name = false,
                highlight_opened_files = "name",
                root_folder_label = ":~:s?$?/..?",
                indent_width = 2,
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                    icons = {
                        corner = "└",
                        edge = "│",
                        item = "│",
                        none = " ",
                    },
                },
                icons = {
                    webdev_colors = true,
                    git_placement = "before",
                    padding = " ",
                    symlink_arrow = " ➛ ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        bookmark = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            },
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },
            system_open = {
                cmd = "",
                args = {},
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                debounce_delay = 50,
                severity = {
                    min = vim.diagnostic.severity.HINT,
                    max = vim.diagnostic.severity.ERROR,
                },
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            filters = {
                dotfiles = true,
                git_clean = false,
                no_buffer = false,
                custom = { "^.git$", "node_modules", "^.cache$" },
                exclude = {},
            },
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
                ignore_dirs = {},
            },
            git = {
                enable = true,
                ignore = false,
                show_on_dirs = true,
                show_on_open_dirs = true,
                timeout = 400,
            },
            modified = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
            },
            actions = {
                use_system_clipboard = true,
                change_dir = {
                    enable = true,
                    global = false,
                    restrict_above_cwd = false,
                },
                expand_all = {
                    max_folder_discovery = 300,
                    exclude = {},
                },
                file_popup = {
                    open_win_config = {
                        col = 1,
                        row = 1,
                        relative = "cursor",
                        border = "shadow",
                        style = "minimal",
                    },
                },
                open_file = {
                    quit_on_open = false,
                    resize_window = true,
                    window_picker = {
                        enable = true,
                        picker = "default",
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                            buftype = { "nofile", "terminal", "help" },
                        },
                    },
                },
                remove_file = {
                    close_window = true,
                },
            },
            trash = {
                cmd = "gio trash",
            },
            live_filter = {
                prefix = "[FILTER]: ",
                always_show_folders = true,
            },
            tab = {
                sync = {
                    open = false,
                    close = false,
                    ignore = {},
                },
            },
            notify = {
                threshold = vim.log.levels.INFO,
            },
            ui = {
                confirm = {
                    remove = true,
                    trash = true,
                },
            },
            experimental = {
                git = {
                    async = true,
                },
            },
            log = {
                enable = false,
                truncate = false,
                types = {
                    all = false,
                    config = false,
                    copy_paste = false,
                    diagnostics = false,
                    git = false,
                    profile = false,
                },
            },
        })
    end,
}