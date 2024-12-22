return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("trouble").setup({
            position = "bottom",
            height = 10,
            icons = true,
            mode = "workspace_diagnostics",
            fold_open = "",
            fold_closed = "",
            group = true,
            padding = true,
            auto_open = false,
            auto_close = true,
            auto_preview = true,
            auto_fold = false,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = "",
            },
            use_diagnostic_signs = true,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
            {silent = true, noremap = true, desc = "Toggle trouble"})
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
            {silent = true, noremap = true, desc = "Workspace diagnostics"})
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
            {silent = true, noremap = true, desc = "Document diagnostics"})
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
            {silent = true, noremap = true, desc = "Location list"})
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            {silent = true, noremap = true, desc = "Quickfix list"})
    end,
}