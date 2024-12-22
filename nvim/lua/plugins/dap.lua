return {
    "mfussenegger/nvim-dap",
    config = function()
        -- Debug Controls
        vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { noremap = true, desc = "Debug: Continue" })
        vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { noremap = true, desc = "Debug: Step Over" })
        vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { noremap = true, desc = "Debug: Step Into" })
        vim.keymap.set("n", "<leader>dt", ":lua require'dap'.step_out()<CR>", { noremap = true, desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, desc = "Debug: Set Conditional Breakpoint" })
        vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { noremap = true, desc = "Debug: Open REPL" })
        vim.keymap.set("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { noremap = true, desc = "Debug: Run Last" })
    end,
}