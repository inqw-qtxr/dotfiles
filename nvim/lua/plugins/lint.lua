return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			-- Python
			python = { "ruff", "pylint", "mypy" },

			-- Shell
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },
			fish = { "shellcheck" },

			-- Go
			go = { "golangcilint" },

			-- JS/TS
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },

			-- Ruby
			ruby = { "rubocop" },
		}

		-- Create an autocmd group for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Add debounce functionality
		local DEBOUNCE_DELAY = 500 -- milliseconds
		local timer = nil

		local function debounce_lint()
			if timer then
				timer:stop()
			end

			timer = vim.defer_fn(function()
				-- Check if buffer is valid and has a filetype with configured linters
				local bufnr = vim.api.nvim_get_current_buf()
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end

				local filetype = vim.bo[bufnr].filetype
				if not filetype or not lint.linters_by_ft[filetype] then
					return
				end

				-- Don't lint if in certain buffer types or filetypes
				local ignored_filetypes = {
					[""] = true,
					["TelescopePrompt"] = true,
					["neo-tree"] = true,
					["dashboard"] = true,
					["lazy"] = true,
					["mason"] = true,
				}
				if ignored_filetypes[filetype] then
					return
				end

				-- Only lint if buffer is modifiable and not too large
				if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
					return
				end

				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				if ok and stats and stats.size > max_filesize then
					return
				end

				-- Finally, try to lint
				pcall(lint.try_lint)
			end, DEBOUNCE_DELAY)
		end

		-- Autocmd to trigger linting on certain events
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				debounce_lint()
			end,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>l", function()
			debounce_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}