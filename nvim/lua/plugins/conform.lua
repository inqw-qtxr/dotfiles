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
			-- Python - multiple formatters running in sequence
			python = {
				"isort", -- Import sorting
				"black", -- Code formatting
				"ruff_fix", -- Quick fixes
				"ruff_format", -- Formatting
			},

			-- Go - running in sequence
			go = {
				"gofumpt", -- Stricter gofmt
				"goimports", -- Manage imports
				"golines", -- Line length fixing
				"golangci-lint", -- Linting
			},

			-- JavaScript/TypeScript
			javascript = { "biome", "prettier" }, -- Biome first, fallback to prettier
			typescript = { "biome", "prettier" },
			javascriptreact = { "biome", "prettier" },
			typescriptreact = { "biome", "prettier" },
			json = { "biome", "prettier" },
			jsonc = { "biome", "prettier" },

			-- Ruby - multiple formatters
			ruby = {
				"rubocop", -- Main Ruby formatter/linter
				"standardrb", -- Alternative Ruby formatter
				"prettier", -- For ERB files
			},

			-- Shell
			sh = { "shfmt", "shellcheck" },
			bash = { "shfmt", "shellcheck" },
			zsh = { "shfmt" },

			-- Global
			["_"] = { "trim_whitespace", "trim_newlines" },
		},

		formatters = {
			-- Python formatters
			black = {
				prepend_args = { "--line-length", "100" },
			},
			isort = {
				prepend_args = { "--profile", "black", "--line-length", "100" },
			},
			ruff_format = {
				prepend_args = { "--line-length", "100" },
			},

			-- Go formatters
			golines = {
				prepend_args = { "--max-len", "100", "--base-formatter", "gofumpt" },
			},
			golangci_lint = {
				prepend_args = { "run", "--fix" },
			},

			-- JavaScript/TypeScript formatters
			biome = {
				prepend_args = {
					"--line-width",
					"100",
					"--indent-style",
					"space",
					"--indent-width",
					"2",
				},
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

			-- Ruby formatters
			rubocop = {
				command = "bundle",
				args = {
					"exec",
					"rubocop",
					"--auto-correct",
					"--format",
					"quiet",
					"--stdin",
					"$FILENAME",
				},
			},
			standardrb = {
				command = "bundle",
				args = {
					"exec",
					"standardrb",
					"--fix",
					"-a",
					"--stdin",
					"$FILENAME",
				},
			},

			-- Shell formatters
			shfmt = {
				prepend_args = { "-i", "2", "-ci", "-bn" },
			},
			shellcheck = {
				prepend_args = { "--shell=bash", "--format=gcc" },
			},
		},

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

			-- Add back filetype exclusions
			local disable_filetypes = {
				"sql",
				"text",
				"conf",
				"config",
				"plain",
				"properties",
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
	end,
}
