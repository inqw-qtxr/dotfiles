return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.g.hijack_directories = {
			enable = true,
			show_in_sidebar = true,
			auto_open = false,
			open_on_setup = false,
			open_on_setup_file = false,
			open_on_setup_root = false,
		}
		vim.opt.termguicolors = true

		local nvim_tree = require("nvim-tree")
		local api = require("nvim-tree.api")

		vim.keymap.set("n", "<leader>E", api.tree.toggle, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>R", api.tree.reload, { noremap = true, silent = true })
	end,
}
