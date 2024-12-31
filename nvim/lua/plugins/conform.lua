return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
		{
			"<leader>mw",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
				vim.cmd("write")
			end,
			mode = "n",
			desc = "Format and write file",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black", "ruff_format", "ruff_fix" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			["markdown.mdx"] = { "prettier" },
			graphql = { "prettier" },
			rust = { "rustfmt" },
			go = { "gofumpt", "goimports", "golines" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			fish = { "fish_indent" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = { "cmake_format" },
			toml = { "taplo" },
			sql = { "sqlfmt" },
			dockerfile = { "dockerfile_format" },
			["_"] = { "trim_whitespace", "trim_newlines" },
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" },
			},
			prettier = {
				prepend_args = {
					"--print-width",
					"100",
					"--tab-width",
					"2",
					"--use-tabs",
					"false",
					"--semi",
					"true",
					"--single-quote",
					"true",
					"--trailing-comma",
					"es5",
					"--bracket-spacing",
					"true",
				},
			},
			black = {
				prepend_args = { "--line-length", "100" },
			},
			isort = {
				prepend_args = { "--profile", "black" },
			},
			clang_format = {
				prepend_args = { "--style", "{BasedOnStyle: Google, IndentWidth: 2}" },
			},
			rustfmt = {
				prepend_args = { "--edition", "2021" },
			},
			golines = {
				prepend_args = { "--max-len", "100", "--base-formatter", "gofumpt" },
			},
		},

		-- Changed format_on_save to use format_after_save instead
		format_after_save = function(bufnr)
			if vim.api.nvim_buf_line_count(bufnr) > 5000 then
				return
			end

			local filename = vim.fn.expand("%:t")
			local extension = vim.fn.expand("%:e")

			local exclude_files = {
				[".env"] = true,
				[".env.local"] = true,
				[".env.development"] = true,
				[".env.production"] = true,
				[".env.test"] = true,
				[".bashrc"] = true,
				[".zshrc"] = true,
				[".bash_profile"] = true,
				[".zsh_profile"] = true,
				[".zshenv"] = true,
				[".bash_aliases"] = true,
				[".zsh_aliases"] = true,
			}

			local disable_filetypes = {
				"sql",
				"text",
				"conf",
				"config",
			}

			if exclude_files[filename] or vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
				return
			end

			return {
				timeout_ms = 500,
				lsp_fallback = true,
			}
		end,

		notify_on_error = true,
		log_level = vim.log.levels.ERROR,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			conform.format({ async = true, lsp_fallback = true, range = range })
		end, { range = true })

		vim.api.nvim_create_user_command("FormatPrettier", function()
			conform.format({
				formatters = { "prettier" },
				async = true,
			})
		end, {})

		local format_group = vim.api.nvim_create_augroup("FormatAutogroup", {})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "package.json",
			group = format_group,
			callback = function()
				conform.format({
					formatters = { "prettier" },
					async = false,
				})
			end,
		})
	end,
}