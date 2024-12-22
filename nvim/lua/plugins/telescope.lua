-- Telescope Plugin Configuration
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",                                      -- Required dependency
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fuzzy finder
        "nvim-telescope/telescope-file-browser.nvim",                 -- File browser extension
        "nvim-telescope/telescope-ui-select.nvim",                    -- UI select extension
        "nvim-telescope/telescope-frecency.nvim",                     -- Frecency-based sorting
        "aaronhallaert/advanced-git-search.nvim",                    -- Enhanced git integration
        "molecule-man/telescope-menufacture",                        -- Menu creation utilities
        "nvim-telescope/telescope-live-grep-args.nvim",              -- Advanced live grep
    },
    cmd = "Telescope", -- Lazy load on Telescope command
    keys = {
        -- File navigation
        { "<leader>ff", "<cmd>Telescope find_files<cr>",    desc = "Find Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",     desc = "Live Grep" },
        { "<leader>fb", "<cmd>Telescope file_browser<cr>",  desc = "File Browser" },
        { "<leader>fr", "<cmd>Telescope frecency<cr>",      desc = "Recent Files (Frecency)" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",     desc = "Help Tags" },
        
        -- Buffer management
        { "<leader>bb", "<cmd>Telescope buffers<cr>",       desc = "List Buffers" },
        
        -- Git integration
        { "<leader>gf", "<cmd>Telescope git_files<cr>",     desc = "Git Files" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>",   desc = "Git Commits" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>",  desc = "Git Branches" },
        { "<leader>gs", "<cmd>Telescope git_status<cr>",    desc = "Git Status" },
        
        -- Advanced git search
        { "<leader>gL", "<cmd>Telescope advanced_git_search diff_branch_file<cr>", desc = "Git Branch Diff" },
        { "<leader>gl", "<cmd>Telescope advanced_git_search diff_commit_file<cr>", desc = "Git Commit Diff" },
    },
    config = function()
        -- Safe require for telescope
        local telescope_setup, telescope = pcall(require, "telescope")
        if not telescope_setup then
            vim.notify("Failed to load telescope", vim.log.levels.ERROR)
            return
        end

        local actions = require("telescope.actions")

        -- Main telescope configuration
        telescope.setup({
            defaults = {
                -- Key mappings
                mappings = {
                    i = { -- Insert mode
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-c>"] = actions.close,
                        ["<C-u>"] = false,
                        ["<C-d>"] = actions.delete_buffer,
                        ["<C-w>"] = false,
                    },
                    n = { -- Normal mode
                        ["<esc>"] = actions.close,
                        ["q"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,
                        ["d"] = actions.delete_buffer,
                    },
                },
                
                -- File and directory ignores
                file_ignore_patterns = {
                    "%.git/.*",
                    "node_modules/.*",
                    "%.DS_Store",
                    "%.class",
                    "%.pdf",
                    "%.mkv",
                    "%.mp4",
                    "%.zip",
                },
                
                -- Ripgrep configuration
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob", "!{.git,node_modules}/**"
                },
                
                -- UI configuration
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
            },
            
            -- Picker-specific configurations
            pickers = {
                find_files = {
                    hidden = true,
                    find_command = {
                        "fd",
                        "--type", "f",
                        "--hidden",
                        "--strip-cwd-prefix",
                        "--exclude", ".git",
                        "--exclude", "node_modules"
                    }
                },
                live_grep = {
                    additional_args = function(opts)
                        return { "--hidden", "--glob", "!{.git,node_modules}/**" }
                    end
                },
                buffers = {
                    show_all_buffers = true,
                    sort_lastused = true,
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer,
                        },
                        n = {
                            ["d"] = actions.delete_buffer,
                        },
                    },
                },
                git_commits = {
                    mappings = {
                        i = {
                            ["<cr>"] = actions.git_checkout,
                        },
                    },
                },
            },
            
            -- Extension configurations
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ui_select = {
                    require("telescope.themes").get_dropdown(),
                },
                frecency = {
                    show_scores = true,
                    show_unindexed = true,
                    ignore_patterns = {"*.git/*", "*/tmp/*"},
                    workspaces = {
                        ["conf"] = "/Users/williamhicks/dotfiles",
                        ["project"] = "/Users/williamhicks/Projects",
                    },
                },
                file_browser = {
                    -- theme = "dropdown",
                    hijack_netrw = true,
                    mappings = {
                        i = {
                            ["<C-h>"] = false,
                        },
                    },
                },
            }
        })

        -- Safe extension loading function
        local function safe_load_extension(name)
            local status_ok, _ = pcall(telescope.load_extension, name)
            if not status_ok then
                vim.notify("Failed to load telescope extension: " .. name, vim.log.levels.WARN)
            end
        end

        -- Load extensions
        local extensions = {
            "fzf",
            "file_browser",
            "ui-select",
            "frecency",
            "advanced_git_search",
            "live_grep_args"
        }

        for _, ext in ipairs(extensions) do
            safe_load_extension(ext)
        end
    end,
}