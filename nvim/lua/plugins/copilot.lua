return {
    "github/copilot.vim",
    config = function()
        -- Disable Copilot's default key mapping for Tab
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        
        -- Use Alt-] to accept Copilot's suggestion instead of Tab
        vim.api.nvim_set_keymap('i', '<M-]>', 'copilot#Accept("<CR>")', {
            expr = true,
            silent = true,
            replace_keycodes = false
        })
        
        -- Navigation keymaps for Copilot
        vim.api.nvim_set_keymap('i', '<M-[>', 'copilot#Previous()', {expr = true, silent = true})
        vim.api.nvim_set_keymap('i', '<M-\\>', 'copilot#Next()', {expr = true, silent = true})
        
        -- Dismiss Copilot suggestion
        vim.api.nvim_set_keymap('i', '<C-]>', 'copilot#Dismiss()', {expr = true, silent = true})
    end,
}