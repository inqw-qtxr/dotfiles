return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"folke/lazydev.nvim",
		"ray-x/lsp_signature.nvim",
		"j-hui/fidget.nvim",
		"smjonas/inc-rename.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saghen/blink.cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	lazy = false,
	priority = 98, -- Lower than mason and mason-lspconfig
	config = function()
		-- Wait for mason-lspconfig to be ready
		local mason_ok, _ = pcall(require, "mason-lspconfig")
		if not mason_ok then
			return
		end

		-- Create augroup first
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- Define on_attach function before using it
		local on_attach = function(client, bufnr)
			require("lsp_signature").setup({
				bind = true,
				handler_opts = { border = "rounded" },
			})

			require("inc_rename").setup({ input_buffer_type = "dressing" })

			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format()
					end,
				})
			end

			if client.server_capabilities.hoverProvider then
				vim.o.updatetime = 100
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							source = "always",
							hint_prefix = " ",
							scope = "cursor",
						}
						vim.diagnostic.open_float(nil, opts)
					end,
				})
			end

			-- navigation keymappings
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { noremap = true, silent = true })

			-- hover documentation and formatting
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { noremap = true, silent = true })

			-- workspaces
			vim.keymap.set("n", "<leader>w", vim.lsp.buf.workspace_symbol, { noremap = true, silent = true })

			-- diagnostics
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

			-- code actions
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
		end

		require("lsp_signature").setup({
			bind = true,
			handler_opts = { border = "rounded" },
			floating_window = false,
			hint_prefix = " ",
		})

		-- Setup LSP configuration
		local lspconfig_ok, lspconfig = pcall(require, "nvim-lspconfig")
		if not lspconfig_ok then
			return
		end

		-- Setup each server
		local servers = {
			"lua_ls",
			"gopls",
			"ruby_lsp",
			"solargraph",
			"rubocop",
			"pyright",
			"ruff",
			"black",
			"jsonls",
			"terraformls",
			"dockerls",
			"docker_compose_language_service",
		}

		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				on_attach = on_attach,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end

		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})

		require("fidget").setup({
			progress = {
				suppress_on_insert = true,
				ignore_done_ready = true,
				ignore_empty_messages = true,
				display = {
					render_limit = 16,
					done_ttl = 3,
					progress_ttl = math.huge,
				},
			},
			notification = {
				window = {
					blend = 0,
					relative = "editor",
					border = "rounded",
				},
			},
		})

		require("inc_rename").setup({ input_buffer_type = "dressing" })
	end,
}
