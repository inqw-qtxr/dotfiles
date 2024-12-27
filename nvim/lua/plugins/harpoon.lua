return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2", -- Use the newer version
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		-- Mark operations
		{
			"<leader>ha",
			function()
				local harpoon = require("harpoon")
				if not harpoon:list() then
					return
				end
				harpoon:list():add()
			end,
			desc = "Add file to harpoon",
		},
		{
			"<leader>he",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Show harpoon menu",
		},
		{
			"<leader>hc",
			function()
				local harpoon = require("harpoon")
				harpoon:list():clear()
			end,
			desc = "Clear all harpoon marks",
		},
		-- Navigation
		{
			"<C-h>",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:select(1)
				end
			end,
			desc = "Navigate to harpoon 1",
		},
		{
			"<C-j>",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:select(2)
				end
			end,
			desc = "Navigate to harpoon 2",
		},
		{
			"<C-k>",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:select(3)
				end
			end,
			desc = "Navigate to harpoon 3",
		},
		{
			"<C-l>",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:select(4)
				end
			end,
			desc = "Navigate to harpoon 4",
		},
		-- Additional navigation
		{
			"[h",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:prev()
				end
			end,
			desc = "Navigate to previous mark",
		},
		{
			"]h",
			function()
				local harpoon = require("harpoon")
				local list = harpoon:list()
				if list then
					list:next()
				end
			end,
			desc = "Navigate to next mark",
		},
	},
	-- The new-style Harpoon settings for the harpoon2 branch
	opts = {
		settings = {
			save_on_toggle = true,
			save_on_change = true,
			enter_on_sendcmd = false,
			tmux_autoclose_windows = false,
			excluded_filetypes = { "harpoon", "neo-tree", "dashboard" },
			mark_branch = true, -- Mark files per git branch
			tabline = false, -- Enable tabline integration
			tabline_prefix = "   ",
			tabline_suffix = "   ",
			menu = {
				width = 60,
				height = 10,
				border = "rounded",
			},
		},
		-- Default view options
		default_list = {
			encode = "json", -- Other options: "base64", "messagepack"
			limit = 10, -- Maximum number of items in list
		},
	},
	config = function(_, opts)
		local harpoon = require("harpoon")

		-- Basic setup
		harpoon:setup(opts)

		-----------------------------------------------------------------------
		-- Autocmd: store "⥤ <index>" in vim.b.harpoon_mark for your statusline
		-----------------------------------------------------------------------
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				vim.schedule(function()
					local list = harpoon:list()
					local current_file_path = vim.fn.expand("%:p")
					-- Add checks for both list and current_file_path
					if list and current_file_path and current_file_path ~= "" then
						-- Add a check to ensure list is valid before calling methods on it
						if list.index_of_file then
							local current_file_index = list:index_of_file(current_file_path)
							if current_file_index then
								vim.b.harpoon_mark = "⥤ " .. current_file_index
							else
								vim.b.harpoon_mark = ""
							end
						else
							vim.b.harpoon_mark = ""
						end
					else
						vim.b.harpoon_mark = ""
					end
				end)
			end,
		})

		-----------------------------------------------------------------------
		-- (Optional) Telescope integration
		-----------------------------------------------------------------------
		local conf = require("telescope.config").values
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local previewers = conf.file_previewer({})
		local sorter = conf.generic_sorter({})

		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			pickers
				.new({}, {
					prompt_title = "Harpoon",
					finder = finders.new_table({ results = file_paths }),
					previewer = previewers,
					sorter = sorter,
				})
				:find()
		end

		vim.keymap.set("n", "<leader>hf", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Find harpoon marks" })

		-----------------------------------------------------------------------
		-- Custom commands
		-----------------------------------------------------------------------
		vim.api.nvim_create_user_command("HarpoonAdd", function()
			harpoon:list():add()
		end, { desc = "Add current file to harpoon" })

		vim.api.nvim_create_user_command("HarpoonRemove", function()
			harpoon:list():remove()
		end, { desc = "Remove current file from harpoon" })

		vim.api.nvim_create_user_command("HarpoonClear", function()
			harpoon:list():clear()
		end, { desc = "Clear all harpoon marks" })
	end,
}

