return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		terminal_colors = true,
		transparent_mode = false,
		contrast = "hard",

		italic = {
			strings = false,
			comments = true,
			operators = false,
			folds = true,
		},

		bold = true,
		underline = true,
		undercurl = true,
	},
	config = function(_, opts)
		require("gruvbox").setup(opts)
		vim.cmd([[colorscheme gruvbox]])
	end,
}
