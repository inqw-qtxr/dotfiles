local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins.gruvbox" },
		{ import = "plugins.autopairs" },
		{ import = "plugins.lualine" },
		{ import = "plugins.conform" },
		{ import = "plugins.comment" },
		{ import = "plugins.copilot" },
		{ import = "plugins.dap" },
		{ import = "plugins.gitsigns" },
		{ import = "plugins.harpoon" },
		{ import = "plugins.lint" },
		{ import = "plugins.lsp" },
		{ import = "plugins.mason-lsp" },
		{ import = "plugins.project" },
		{ import = "plugins.telescope" },
		{ import = "plugins.tree" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.treesitter-context" },
		{ import = "plugins.trouble" },
		{ import = "plugins.noice" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	checker = { enabled = true },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
