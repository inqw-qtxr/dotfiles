return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source", "comment" },
				javascript = { "template_string", "string", "comment" },
				typescript = { "template_string", "string", "comment" },
				java = false,
				python = { "string", "f_string" },
			},
			disable_filetype = {
				"TelescopePrompt",
				"vim",
				"spectre_panel",
				"dirvish",
				"fugitive",
				"alpha",
				"nvimtree",
				"lazy",
			},
			ignored_next_char = "[%w%.%(%{%[%'%\"%`]",
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'", "`", "<" },
				pattern = [=[[%'%"%>%]%)%}%,%;%`%$]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				manual_position = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
				offset = -1,
			},
			enable_check_bracket_line = true,
			disable_in_macro = true,
			disable_in_visualblock = true,
			disable_in_replace_mode = true,
			enable_moveright = true,
			enable_afterquote = true,
			enable_bracket_in_quote = true,
			map_cr = true,
			map_bs = true,
			break_undo = true,
			map_c_h = true,
			map_c_w = true,
		})

		npairs.add_rules({
			-- Space handling rules
			Rule(" ", " ")
				:with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ "()", "[]", "{}", "<>" }, pair)
				end)
				:with_move(cond.none())
				:with_cr(cond.none())
				:with_del(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local context = opts.line:sub(col - 1, col + 2)
					return vim.tbl_contains({ "(  )", "[  ]", "{  }", "<  >" }, context)
				end),

			-- Bracket movement rules
			Rule("", " )")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == ")"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key(")"),
			Rule("", " ]")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == "]"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key("]"),
			Rule("", " }")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == "}"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key("}"),
			Rule("", " >")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == ">"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key(">"),

			-- Python f-strings
			Rule('f"', '"', "python"),
			Rule("f'", "'", "python"),

			-- JSX/TSX
			Rule("$", "$", { "typescript", "javascript", "typescriptreact", "javascriptreact" })
				:with_pair(cond.not_before_regex("%w"))
				:with_pair(cond.not_after_regex("%w")),

			-- LaTeX
			Rule("\\(", "\\)", { "tex", "latex" }),
			Rule("\\[", "\\]", { "tex", "latex" }),
			Rule("\\{", "\\}", { "tex", "latex" }),

			-- String interpolation
			Rule("#{", "}", { "ruby", "elixir" }):with_pair(cond.not_before_regex("%w")),

			-- Enhanced markdown rules
			Rule("`", "`", { "markdown", "vimwiki", "mdx", "text" })
				:with_pair(cond.not_before_text(" "))
				:with_pair(cond.not_after_text(" "))
				:with_pair(cond.not_after_regex("^%s*$")),
			Rule("```", "```", { "markdown", "vimwiki", "mdx" }):with_pair(function(opts)
				local line = opts.line
				local col = opts.col
				return col == 3 and line:sub(1, col) == "```" and not line:match("^```%s*[%w_-]+%s*$")
			end):with_cr(function(opts)
				return true
			end),

			-- HTML/JSX/TSX tags
			Rule("<", ">", { "html", "typescript", "javascript", "javascriptreact", "typescriptreact" })
				:with_pair(cond.not_before_regex("%w"))
				:with_move(function(opts)
					return opts.char == ">"
				end),
		})

		-- nvim-cmp integration
		local ok, cmp = pcall(require, "cmp")
		if ok then
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local handlers = require("nvim-autopairs.completion.handlers")
			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					filetypes = {
						["*"] = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
									cmp.lsp.CompletionItemKind.Constructor,
								},
								handler = handlers["*"],
							},
						},
						tex = false,
						plaintex = false,
						markdown = false,
					},
				})
			)
		end

		vim.keymap.set("i", "<C-'>", function()
			if vim.fn.pumvisible() == 0 then
				return npairs.check_break_undo_key("'")
			end
			return "'"
		end, { expr = true, noremap = true })
	end,
}
