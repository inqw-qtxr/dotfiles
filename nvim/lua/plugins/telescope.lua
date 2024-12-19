return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Tags" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
        { "<leader>fd", "<cmd>Telescope file_browser<cr>",              desc = "File Browser" },
        { "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Current Buffer" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document Symbols" },
        { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace Symbols" },
        { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Current Buffer" },
        { "<leader>fm", "<cmd>Telescope marks<cr>",                     desc = "Browse Marks" },
        { "<leader>ft", "<cmd>Telescope treesitter<cr>",                desc = "Browse Treesitter Symbols" },
        { "<leader>gf", "<cmd>Telescope git_files<cr>",                 desc = "Git Files" },
        { "<leader>fW", "<cmd>Telescope grep_string<cr>",               desc = "Find word under cursor" },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        -- Custom picker for test results
        local function test_picker()
            local test_results = vim.fn["test#get_last_results"]()
            if not test_results or not test_results.messages then
                vim.notify("No test results available", vim.log.levels.WARN)
                return
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Test Results",
                finder = require("telescope.finders").new_table({
                    results = test_results.messages,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry,
                            ordinal = entry,
                        }
                    end,
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                previewer = require("telescope.config").values.generic_previewer({}),
            }):find()
        end

        -- Configure telescope
        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    ".git/",
                    "target/",
                    "dist/",
                    "build/",
                    "%.lock"
                },
                layout_config = {
                    horizontal = {
                        preview_cutoff = 120,
                        preview_width = 0.6,
                    },
                    prompt_position = "bottom",
                    width = 0.87,
                    height = 0.80,
                },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-c>"] = actions.close,
                        ["<C-u>"] = false, -- Clear prompt
                        ["<C-w>"] = false, -- Clear word
                    },
                    n = {
                        ["<esc>"] = actions.close,
                        ["q"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                },
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
            pickers = {
                find_files = {
                    hidden = true,
                    find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" }
                },
                live_grep = {
                    additional_args = function(opts)
                        return { "--hidden" }
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
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            }
        })

        -- Load extensions
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "file_browser")

        -- Make test_picker function globally available
        vim.g.telescope_test_picker = test_picker
    end,
}

