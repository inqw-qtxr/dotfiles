return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 100,
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 99,
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local lsps = {
				"lua_ls",
				"gopls",
				"solargraph",
				"ruff",
				"jsonls",
				"terraformls",
				"dockerls",
				"docker_compose_language_service",
				"pyright",
			}

			local daps = {
				"delve",
				"debugpy",
			}

			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = lsps, -- Corrected variable name from 'servers' to 'lsps'
				automatic_installation = true,
			})

			require("mason-lspconfig.dap").setup({
				ensure_installed = daps,
				automatic_installation = true,
			})
		end,
	},
}
