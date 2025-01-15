return {
	"numToStr/Comment.nvim",
	config = function()
		local comment = require("Comment")
		comment.setup({
			toggler = {
				line = "<leader>/",
				block = "<leader>#",
			},
		})
	end,
}
