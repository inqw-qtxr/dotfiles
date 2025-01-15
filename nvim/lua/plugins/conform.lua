return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			ruby = { "rubocop" },
			sql = { "sqlformat" },
			sh = { "shfmt" },
			lua = { "stylua" },
			python = { "black", "isort" },
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			yaml = { "yamlfmt" },
			html = { "djlint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			go = { "gofumpt", "gopls", "golines" },
			rust = { "rustfmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" },
			},
		},
		notify_on_error = true,
		log_level = vim.log.levels.ERROR,
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
