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
			local os_name = vim.loop.os_uname().sysname

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

			if os_name == "Linux" then
				table.insert(lsps, "clangd")
				table.insert(daps, "lldb")
			elseif os_name == "Windows_NT" then
				table.insert(lsps, "powershell_es")
				table.insert(daps, "cppvsdbg")
			end

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
				ensure_installed = lsps,
				automatic_installation = true,
			})
		end,
	},
}
