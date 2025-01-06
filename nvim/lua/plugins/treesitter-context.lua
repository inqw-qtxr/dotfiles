return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPost", "BufNewFile" }, -- Load when needed
	keys = {
		{ "[c", desc = "Go to context" },
		{ "<leader>tc", desc = "Toggle treesitter context" },
		{ "<leader>tC", desc = "Toggle treesitter context sticky" },
	},
	config = function()
		local tscontext = require("treesitter-context")
		local augroup = vim.api.nvim_create_augroup("TreesitterContext", { clear = true })

		tscontext.setup({
			enable = true,
			max_lines = 0, -- No limit
			min_window_height = 0, -- No limit
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = "─", -- Added separator for better visibility
			zindex = 20,
			on_attach = function(buf)
				-- Check if LSP is attached
				local clients = vim.lsp.get_active_clients({ bufnr = buf })
				if #clients > 0 then
					-- Enhance context display for LSP-enabled buffers
					vim.api.nvim_buf_set_var(buf, "treesitter_context_update_delay", 100) -- Faster updates when LSP is active
				end
			end,

			patterns = {
				-- Default patterns
				default = {
					"class",
					"function",
					"method",
					"for",
					"while",
					"if",
					"switch",
					"case",
					"interface",
					"struct",
					"enum",
					-- Add these LSP-specific patterns
					"namespace",
					"module",
					"implementation",
				},

				-- Specific patterns for different languages
				typescript = {
					"class_declaration",
					"interface_declaration",
					"enum_declaration",
					"function_declaration",
					"method_declaration",
					"arrow_function",
					"block",
					-- Add these TypeScript-specific patterns
					"export_statement",
					"import_statement",
					"module_declaration",
				},

				python = {
					"class_definition",
					"function_definition",
					"for_statement",
					"while_statement",
					"if_statement",
					"try_statement",
					"with_statement",
					"match_statement",
				},

				lua = {
					"function",
					"if_statement",
					"for_statement",
					"while_statement",
					"function_definition",
					"table_constructor",
				},

				rust = {
					"impl_item",
					"struct_item",
					"enum_item",
					"function_item",
					"loop_expression",
					"if_expression",
					"match_expression",
					-- Add these Rust-specific patterns
					"trait_item",
					"mod_item",
					"macro_definition",
				},

				go = {
					"function_declaration",
					"method_declaration",
					"type_declaration",
					"if_statement",
					"for_statement",
					"switch_statement",
				},
			},

			exact_patterns = {
				-- Exact patterns (no word boundaries)
				rust = {
					"impl",
					"loop",
				},
			},
		})

		-- Enhanced keymaps
		local function map(mode, lhs, rhs, opts)
			local options = { noremap = true, silent = true }
			if opts then
				options = vim.tbl_extend("force", options, opts)
			end
			vim.keymap.set(mode, lhs, rhs, options)
		end

		-- Navigation and toggle
		map("n", "[c", function()
			tscontext.go_to_context(vim.v.count1) -- Support count for multiple jumps
		end, { desc = "Go to context" })

		map("n", "<leader>tc", function()
			tscontext.toggle()
			vim.notify("Treesitter context: " .. (tscontext.enabled() and "enabled" or "disabled"))
		end, { desc = "Toggle treesitter context" })

		-- Additional mapping for sticky context
		map("n", "<leader>tC", function()
			if vim.b.ts_context_sticky then
				vim.b.ts_context_sticky = false
				vim.notify("Treesitter context sticky: disabled")
			else
				vim.b.ts_context_sticky = true
				vim.notify("Treesitter context sticky: enabled")
			end
		end, { desc = "Toggle treesitter context sticky" })

		-- Autocommands for better integration
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = { "help", "startify", "dashboard", "neo-tree", "neogitstatus", "oil", "lir" },
			callback = function()
				vim.b.ts_context_disabled = true
			end,
		})

		-- Handle very large files
		vim.api.nvim_create_autocmd("BufReadPost", {
			group = augroup,
			callback = function(ev)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, ev.file)
				if ok and stats and stats.size > max_filesize then
					vim.b.ts_context_disabled = true
				end
			end,
		})

		-- Highlight setup
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "LineNr" })
		vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "Comment" })

		-- Optional: Status line integration
		vim.api.nvim_create_autocmd("User", {
			group = augroup,
			pattern = "TreesitterContextCallback",
			callback = function()
				-- You can integrate with your status line here
				vim.cmd("redrawstatus!")
			end,
		})
	end,
}
