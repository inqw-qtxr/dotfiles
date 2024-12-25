return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Optional but recommended
		"rcarriga/nvim-dap-ui", -- UI for nvim-dap
		"theHamsta/nvim-dap-virtual-text", -- Show variable values as virtual text
		"nvim-telescope/telescope-dap.nvim", -- Telescope integration
	},
	keys = {
		-- Debug controls with better organization
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Continue",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>dt",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input({
					prompt = "Breakpoint condition: ",
				}))
			end,
			desc = "Debug: Set Conditional Breakpoint",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Debug: Open REPL",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run Last",
		},
		-- Additional useful debug commands
		{
			"<leader>dh",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "Debug: Hover Variables",
			mode = { "n", "v" },
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "Debug: Pause",
		},
		{
			"<leader>df",
			function()
				require("dap").focus_frame()
			end,
			desc = "Debug: Focus Frame",
		},
		{
			"<leader>ds",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Stop",
		},
	},
	config = function()
		local dap = require("dap")

		-- UI Configuration
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "●", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
		)

		-- Enhanced REPL configuration
		dap.repl.commands = vim.tbl_extend("force", dap.repl.commands, {
			-- Custom REPL commands
			continue = { "c", "continue" },
			next_ = { "n", "next" },
			step = { "s", "step" },
			run_last = { "r", "run_last" },
		})

		-- DAP-UI Setup (if installed)
		local has_dapui, dapui = pcall(require, "dapui")
		if has_dapui then
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.33 },
							{ id = "breakpoints", size = 0.17 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 0.33,
						position = "right",
					},
					{
						elements = {
							{ id = "repl", size = 0.45 },
							{ id = "console", size = 0.55 },
						},
						size = 0.27,
						position = "bottom",
					},
				},
			})

			-- Automatically open/close dapui
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end

		-- Virtual Text Setup (if installed)
		local has_virtual_text, virtual_text = pcall(require, "nvim-dap-virtual-text")
		if has_virtual_text then
			virtual_text.setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
			})
		end

		-- Telescope-DAP Setup (if installed)
		local has_telescope, telescope = pcall(require, "telescope")
		if has_telescope then
			telescope.load_extension("dap")

			-- Additional keymaps for Telescope integration
			vim.keymap.set("n", "<leader>dcc", function()
				require("telescope").extensions.dap.commands({})
			end, { desc = "Debug: Commands" })
			vim.keymap.set("n", "<leader>dco", function()
				require("telescope").extensions.dap.configurations({})
			end, { desc = "Debug: Configurations" })
		end

		-- Add useful commands
		vim.api.nvim_create_user_command("DapRunToCursor", function()
			require("dap").run_to_cursor()
		end, {})

		vim.api.nvim_create_user_command("DapSetLogpoint", function()
			require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
		end, {})
	end,
}

