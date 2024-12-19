return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        require("Comment").setup({
            -- Enable line and block comment toggling
            toggler = {
                line = 'gcc',
                block = 'gbc',
            },
            -- Enable operator-pending mappings
            opleader = {
                line = 'gc',
                block = 'gb',
            },
            -- Enable extra mappings
            extra = {
                above = 'gcO',
                below = 'gco',
                eol = 'gcA',
            },
            -- Enable context aware commenting if ts_context_commentstring is available
            pre_hook = function()
                local ok, context_commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
                if ok then
                    return context_commentstring.create_pre_hook()
                end
                return nil
            end,
        })

        -- Additional keymaps for specific modes if needed
        vim.keymap.set("n", "<leader>/", function()
            require("Comment.api").toggle.linewise.current()
        end, { desc = "Toggle comment line" })
        
        vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            { desc = "Toggle comment for selection" })
    end,
}