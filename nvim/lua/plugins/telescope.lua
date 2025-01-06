return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"debugloop/telescope-undo.nvim", -- Undo history
	},
	cmd = "Telescope",
	keys = {
		-- File navigation
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep (with args)" },
		{ "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
		{ "<leader>fr", "<cmd>Telescope frecency<cr>", desc = "Recent Files (Frecency)" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word Under Cursor" },

		-- Buffer management
		{ "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },

		-- Git integration
		{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
		{ "<leader>gL", "<cmd>Telescope advanced_git_search diff_branch_file<cr>", desc = "Git Branch Diff" },
		{ "<leader>gl", "<cmd>Telescope advanced_git_search diff_commit_file<cr>", desc = "Git Commit Diff" },

		-- Additional features
		{ "<leader>u", "<cmd>Telescope undo<cr>", desc = "Undo History" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Search Diagnostics" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps" },

		-- LSP Integration
		{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "LSP Document Symbols" },
		{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
		{ "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
		{ "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "LSP Buffer Diagnostics" },
		{ "<leader>lD", "<cmd>Telescope diagnostics<cr>", desc = "LSP Workspace Diagnostics" },
		{ "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
		{ "<leader>lc", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "LSP Incoming Calls" },
		{ "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "LSP Outgoing Calls" },

		-- Harpoon Integration (in addition to existing harpoon.ui)
		{ "<leader>hm", "<cmd>Telescope harpoon marks<cr>", desc = "Harpoon Marks" },
	},
	config = function()
		local telescope_setup, telescope = pcall(require, "telescope")
		if not telescope_setup then
			vim.notify("Failed to load telescope", vim.log.levels.ERROR)
			return
		end

		local actions = require("telescope.actions")
		local lga_actions = require("telescope-live-grep-args.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-c>"] = actions.close,
						["<C-u>"] = false,
						["<C-d>"] = actions.delete_buffer,
						["<C-w>"] = false,
						["<C-s>"] = actions.select_horizontal, -- Split horizontal
						["<C-v>"] = actions.select_vertical, -- Split vertical
						["<C-t>"] = actions.select_tab, -- Open in new tab
						["<C-/>"] = actions.which_key, -- Show mappings
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<CR>"] = actions.select_default,
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
						["d"] = actions.delete_buffer,
						["s"] = actions.select_horizontal,
						["v"] = actions.select_vertical,
						["t"] = actions.select_tab,
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
					"target/.*", -- Rust/Java builds
					"dist/.*", -- JavaScript builds
					"build/.*", -- General builds
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
					"--trim", -- Remove leading/trailing whitespace
				},

				-- Enhanced UI configuration
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
					vertical = {
						mirror = false,
					},
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

				-- Better preview handling
				preview = {
					timeout = 500,
					msg_bg_fillchar = "╱",
					hide_on_startup = false,
				},

				-- Better performance
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
					additional_args = function(opts)
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
				lsp_references = {
					theme = "dropdown",
					initial_mode = "normal",
				},
				lsp_implementations = {
					theme = "dropdown",
					initial_mode = "normal",
				},
				lsp_definitions = {
					theme = "dropdown",
					initial_mode = "normal",
				},
				diagnostics = {
					theme = "dropdown",
					initial_mode = "normal",
					layout_config = {
						width = 0.95,
						height = 0.85,
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
				ui_select = {
					require("telescope.themes").get_dropdown({
						initial_mode = "normal",
						sorting_strategy = "ascending",
						layout_strategy = "center",
						results_title = false,
						layout_config = {
							width = 0.5,
							height = 0.4,
						},
					}),
				},
				frecency = {
					show_scores = true,
					show_unindexed = true,
					ignore_patterns = {
						"*.git/*",
						"*/tmp/*",
						"*/node_modules/*",
						"*/vendor/*",
						"*/dist/*",
						"*/build/*",
					},
					workspaces = {
						["conf"] = "~/dotfiles",
						["boost-client"] = "~/github.com/boost-legal/boost-client",
						["boost-api"] = "~/github.com/boost-legal/boost-api",
						["hum-server"] = "~/Projects/HumServer",
					},
				},
				file_browser = {
					hijack_netrw = true,
					hidden = true,
					respect_gitignore = false,
					mappings = {
						i = {
							["<C-h>"] = false,
						},
					},
				},
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
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
			"live_grep_args",
			"undo",
		}

		for _, ext in ipairs(extensions) do
			safe_load_extension(ext)
		end

		-- Add workspace symbols configuration
		telescope.register_extension({
			exports = {
				smart_workspace = function(opts)
					local pickers = require("telescope.pickers")
					local finders = require("telescope.finders")
					local previewers = require("telescope.previewers")
					local conf = require("telescope.config").values

					local harpoon_marks = require("harpoon"):list()
					local results = {}

					-- Add Harpoon marks
					for _, mark in ipairs(harpoon_marks.items) do
						table.insert(results, {
							value = mark.value,
							display = "📌 " .. vim.fn.fnamemodify(mark.value, ":t"),
							ordinal = mark.value,
							filename = mark.value,
						})
					end

					-- Create the picker
					pickers
						.new(opts, {
							prompt_title = "Smart Workspace",
							finder = finders.new_table({
								results = results,
								entry_maker = function(entry)
									return entry
								end,
							}),
							previewer = previewers.vim_buffer_cat.new(opts),
							sorter = conf.generic_sorter(opts),
						})
						:find()
				end,
			},
		})
	end,
}
