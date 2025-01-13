return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-refactor",
		"windwp/nvim-ts-autotag",
		"RRethy/nvim-treesitter-textsubjects",
	},
	config = function()
		local configs = require("nvim-treesitter.configs")
		local ensure_installed = {
			"lua",
			"go",
			"gomod",
			"bash",
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"json",
			"ruby",
			"python",
			"yaml",
			"regex",
			"vim",
			"query",
		}

		configs.setup({
			ensure_installed = ensure_installed,
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 5000 * 1024 -- 5mb
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
				disable = { "yaml" },
			},
			autotag = {
				enable = true,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<C-backspace>",
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
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ap"] = "@parameter.outer",
						["ip"] = "@parameter.inner",
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
						["ab"] = "@conditional.outer",
						["ib"] = "@conditional.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aA"] = "@attribute.outer",
						["iA"] = "@attribute.inner",
						["aF"] = "@frame.outer",
						["iF"] = "@frame.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "v",
						["@class.outer"] = "<c-v>",
					},
				},
			},

			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]M"] = "@class.outer",
					["]c"] = "@conditional.outer",
					["]l"] = "@loop.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[M"] = "@class.outer",
					["[c"] = "@conditional.outer",
					["[l"] = "@loop.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
				},
			},

			refactor = {
				highlight_definitions = {
					enable = true,
					clear_on_cursor_move = true,
				},
				highlight_current_scope = { enable = false },
				smart_rename = {
					enable = true,
					keymaps = {
						smart_rename = "grr",
					},
				},
				navigation = {
					enable = true,
					keymaps = {
						goto_definition = "gnd",
						list_definitions = "gnD",
						list_definitions_toc = "gO",
						goto_next_usage = "<a-*>",
						goto_previous_usage = "<a-#>",
					},
				},
			},

			textsubjects = {
				enable = true,
				prev_selection = ",",
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = "textsubjects-container-inner",
				},
			},
		})
	end,
}
