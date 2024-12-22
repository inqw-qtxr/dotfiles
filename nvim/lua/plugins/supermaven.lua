return {
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({
            -- Default configuration
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<Tab>",
                    next = "<C-]>",
                    prev = "<C-[>",
                    dismiss = "<C-\\>",
                }
            },
        })

        -- Additional keymaps
        vim.keymap.set('i', '<C-p>', '<cmd>lua require("supermaven-nvim.api").next()<CR>', { silent = true })
        vim.keymap.set('i', '<C-o>', '<cmd>lua require("supermaven-nvim.api").previous()<CR>', { silent = true })
        vim.keymap.set('i', '<C-u>', '<cmd>lua require("supermaven-nvim.api").dismiss()<CR>', { silent = true })

        -- Panel controls
        vim.keymap.set("n", "<leader>sm", "<cmd>SupermavenStart<CR>", { noremap = true, desc = "Start Supermaven" })
        vim.keymap.set("n", "<leader>sd", "<cmd>SupermavenStop<CR>", { noremap = true, desc = "Stop Supermaven" })
        vim.keymap.set("n", "<leader>se", "<cmd>SupermavenToggle<CR>", { noremap = true, desc = "Toggle Supermaven" })
    end,
}