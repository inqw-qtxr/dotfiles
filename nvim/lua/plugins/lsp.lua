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
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	lazy = false,
	priority = 98,
	config = function()
		-- Check for mason-lspconfig
		local mason_ok, _ = pcall(require, "mason-lspconfig")
		if not mason_ok then
			return
		end

		-- Create format augroup
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- LSP Signature setup
		require("lsp_signature").setup({
			bind = true,
			handler_opts = { border = "rounded" },
			floating_window = false,
			hint_prefix = " ",
		})

		-- Define on_attach function
		local on_attach = function(client, bufnr)
			-- Setup rename
			require("inc_rename").setup({ input_buffer_type = "dressing" })

			-- Setup formatting on save
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

			-- Setup hover diagnostics
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

			-- Keymappings
			local opts = { noremap = true, silent = true }
			-- Navigation
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

			-- Workspace
			vim.keymap.set("n", "<leader>w", vim.lsp.buf.workspace_symbol, opts)

			-- Formatting
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

			-- Diagnostics
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			-- Code actions
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end

		-- Setup completion
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Setup cmp
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "luasnip", group_index = 2 },
				{ name = "buffer", group_index = 3 },
				{ name = "path", group_index = 3 },
			}),
			formatting = {
				format = function(entry, vim_item)
					vim_item.menu = ({
						copilot = "[Copilot]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]
					return vim_item
				end,
			},
			experimental = {
				ghost_text = true,
			},
		})

		-- Command line completion
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
		})

		-- Setup LSP servers
		local lspconfig_ok, lspconfig = pcall(require, "nvim-lspconfig")
		if not lspconfig_ok then
			return
		end

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

		-- Setup additional plugins
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
