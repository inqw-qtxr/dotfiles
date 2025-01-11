return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup({
			-- Detection methods for projects
			patterns = {
				".git",
				"package.json",
				"go.mod",
				"Cargo.toml",
				"Gemfile",
				"pyproject.toml",
				"Makefile",
				".project",
				".svn",
				"gradlew",
				".idea",
			},
			show_hidden = true,
			silent_chdir = true,
			scope_chdir = "tab",
			datapath = vim.fn.stdpath("data"),
			manual_mode = false,
			exclude_dirs = {
				"~/.cargo/*",
				"~/.local/*",
				"~/.cache/*",
			},
			on_project_detected = function(path)
				vim.notify("Project detected: " .. path, vim.log.levels.INFO)
			end,
		})

		require("telescope").load_extension("projects")

		vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find projects" })
	end,
	keys = {
		{ "<leader>fp", desc = "Find projects" },
	},
}
