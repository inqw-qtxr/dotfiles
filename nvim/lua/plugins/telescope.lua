return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		"molecule-man/telescope-menufacture",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"debugloop/telescope-undo.nvim",
		"nvim-telescope/telescope-project.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"nvim-telescope/telescope-z.nvim",
		"ThePrimeagen/harpoon",
		"folke/noice.nvim",
		"folke/which-key.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		"kdheepak/lazygit.nvim",
	},
	cmd = "Telescope",
	keys = {
		-- File navigation
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep (with args)" },
		{ "<leader>fG", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
		{ "<leader>fr", "<cmd>Telescope frecency<cr>", desc = "Frecency (Recent Files)" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word Under Cursor" },
		{ "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },
		{ "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },

		-- Git integration
		{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
		{ "<leader>gS", "<cmd>Telescope advanced_git_search<cr>", desc = "Advanced Git Search" },

		-- LSP integration
		{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
		{ "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
		{ "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
		{ "<leader>la", "<cmd>Telescope lsp_code_actions<cr>", desc = "LSP Code Actions" },

		-- DAP integration
		{ "<leader>db", "<cmd>Telescope dap list_breakpoints<cr>", desc = "DAP List Breakpoints" },
		{ "<leader>df", "<cmd>Telescope dap frames<cr>", desc = "DAP Frames" },
		{ "<leader>dv", "<cmd>Telescope dap variables<cr>", desc = "DAP Variables" },

		-- Additional utilities
		{ "<leader>u", "<cmd>Telescope undo<cr>", desc = "Undo History" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Search Diagnostics" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search Marks" },
		{ "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search Registers" },
		{ "<leader>st", "<cmd>Telescope treesitter<cr>", desc = "Search Treesitter" },
	},
	config = function()
		local telescope_ok, telescope = pcall(require, "telescope")
		if not telescope_ok then
			vim.notify("Failed to load telescope", vim.log.levels.ERROR)
			return
		end

		local actions = require("telescope.actions")
		local lga_actions = require("telescope-live-grep-args.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						-- Navigation
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,

						-- Basic actions
						["<C-c>"] = actions.close,
						["<C-u>"] = false,
						["<C-d>"] = actions.delete_buffer,
						["<C-w>"] = false,

						-- Splits + tabs
						["<C-s>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						-- Quickfix
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

						-- Help
						["<C-/>"] = actions.which_key,
					},
					n = {
						["<esc>"] = actions.close,
						["q"] = actions.close,

						-- Navigation
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,

						-- Buffer
						["d"] = actions.delete_buffer,

						-- Splits + tabs
						["s"] = actions.select_horizontal,
						["v"] = actions.select_vertical,
						["t"] = actions.select_tab,

						-- Help
						["?"] = actions.which_key,
					},
				},

				file_ignore_patterns = {
					"%.git/.*",
					"node_modules/.*",
					"%.DS_Store",
					"%.class",
					"%.pdf",
					"%.mkv",
					"%.mp4",
					"%.zip",
					"%.tar.gz",
					"%.tar",
					"target/.*",
					"dist/.*",
					"build/.*",
					"%.cache/.*",
					"%.idea/.*",
					"%.vscode/.*",
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
					"--glob",
					"!{.git,node_modules,target,dist,build}/**",
					"--trim",
				},

				prompt_prefix = " ",
				selection_caret = " ",
				entry_prefix = "  ",
				multi_icon = "",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = { mirror = false },
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				path_display = { "truncate" },
				winblend = 0,
				border = {},
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" },

				preview = {
					timeout = 500,
					msg_bg_fillchar = "╱",
					hide_on_startup = false,
				},

				cache_picker = {
					num_pickers = 10,
					limit_entries = 1000,
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"fd",
						"--type",
						"f",
						"--hidden",
						"--strip-cwd-prefix",
						"--exclude",
						".git",
						"--exclude",
						"node_modules",
						"--exclude",
						"target",
						"--exclude",
						"dist",
						"--exclude",
						"build",
					},
				},
				live_grep = {
					additional_args = function(_)
						return { "--hidden", "--glob", "!{.git,node_modules,target,dist,build}/**" }
					end,
				},
				buffers = {
					show_all_buffers = true,
					sort_lastused = true,
					previewer = false,
					mappings = {
						i = { ["<c-d>"] = actions.delete_buffer },
						n = { ["d"] = actions.delete_buffer },
					},
				},
				git_commits = {
					mappings = {
						i = { ["<cr>"] = actions.git_checkout },
					},
				},
				oldfiles = {
					prompt_title = "Recent Files",
					previewer = false,
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				frecency = {
					show_scores = true,
					show_unindexed = true,
					ignore_patterns = { "*.git/*", "*/tmp/*" },
					workspaces = {
						["github"] = "~/github.com",
						["conf"] = "~/dotfiles",
						["project"] = "~/Projects",
					},
				},
				file_browser = {
					hijack_netrw = false,
					hidden = true,
					respect_gitignore = false,
				},
				advanced_git_search = {
					show_builtin_git_pickers = true,
				},
				project = {
					base_dirs = {
						"~/dotfiles",
						"~/Projects",
						"~/github.com",
					},
					hidden_files = true,
					theme = "dropdown",
				},
				undo = {
					side_by_side = true,
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.8,
					},
				},
			},
		})

		-- Load all extensions
		local extensions = {
			"fzf",
			"file_browser",
			"ui-select",
			"frecency",
			"advanced_git_search",
			"menufacture",
			"live_grep_args",
			"undo",
			"project",
			"dap",
			"z",
			"harpoon",
			"noice",
			"which-key",
			"symbols",
			"lazygit",
		}

		for _, ext in ipairs(extensions) do
			local ok = pcall(telescope.load_extension, ext)
			if not ok then
				vim.notify("Failed to load telescope extension: " .. ext, vim.log.levels.WARN)
			end
		end
	end,
}
