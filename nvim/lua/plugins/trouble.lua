return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup({
			icons = true,
			auto_close = true,
			group = true,
			auto_preview = true,
			use_diagnostic_signs = true,
			signs = {
				error = "",
				warning = "",
				hint = "",
				information = "",
			},
		})
	end,
}
