return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			terminal_colors = true,
			transparent_mode = false,
			contrast = "hard",
			palette_overrides = {},
			overrides = {
				SignColumn = { bg = "NONE" },
				GruvboxGreenSign = { bg = "NONE" },
				GruvboxAquaSign = { bg = "NONE" },
				GruvboxRedSign = { bg = "NONE" },
				GruvboxBlueSign = { bg = "NONE" },
				GruvboxYellowSign = { bg = "NONE" },
				GruvboxPurpleSign = { bg = "NONE" },
				GruvboxOrangeSign = { bg = "NONE" },
			},
			italic = {
				strings = false,
				comments = true,
				operators = false,
				keywords = true,
				functions = false,
				variables = false,
			},
			bold = true,
			underline = true,
			undercurl = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true,
			dim_inactive = false,
		})
		vim.cmd([[colorscheme gruvbox]])
	end,
}
