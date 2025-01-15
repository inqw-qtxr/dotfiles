return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
	},
	keys = {
		{
			"<leader>??",
			function()
				local wk = require("which-key")
				wk.show({ global = false })
			end,
			desc = "Buffer local keymaps",
		},
	},
}
