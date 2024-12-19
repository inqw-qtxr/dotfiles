return {
    "github/copilot.vim",
    config = function()
        -- Additional keymaps
        vim.keymap.set('i', '<C-]>', '<Plug>(copilot-next)', { silent = true })
        vim.keymap.set('i', '<C-[>', '<Plug>(copilot-previous)', { silent = true })
        vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-dismiss)', { silent = true })

        -- Panel controls
        vim.keymap.set("n", "<leader>co", ":Copilot panel<CR>", { noremap = true, desc = "Open Copilot panel" })
        vim.keymap.set("n", "<leader>cdp", ":Copilot disable<CR>", { noremap = true, desc = "Disable Copilot" })
        vim.keymap.set("n", "<leader>cep", ":Copilot enable<CR>", { noremap = true, desc = "Enable Copilot" })
    end,
}
