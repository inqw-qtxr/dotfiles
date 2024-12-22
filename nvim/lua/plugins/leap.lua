return {
    "ggandor/leap.nvim",
    dependencies = {
        "tpope/vim-repeat",
    },
    config = function()
        local leap = require('leap')
        leap.add_default_mappings()
        
        -- Custom keymaps for enhanced navigation
        vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward-to)', { desc = "Leap forward to" })
        vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward-to)', { desc = "Leap backward to" })
        
        -- Configure leap settings
        leap.opts.highlight_unlabeled_phase_one_targets = true
        leap.opts.safe_labels = {}
    end,
}