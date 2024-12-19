return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                }
            }
        })

        -- Custom terminal functions
        local Terminal = require("toggleterm.terminal").Terminal

        -- Create specific terminals for different purposes
        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            float_opts = {
                border = "double",
            },
        })

        local node = Terminal:new({ cmd = "node", hidden = true })
        local python = Terminal:new({ cmd = "python", hidden = true })

        -- Function to toggle lazygit
        function _lazygit_toggle()
            lazygit:toggle()
        end

        -- Keymaps
        vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })
        vim.keymap.set("n", "<leader>tg", ":lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle lazygit" })
        vim.keymap.set("n", "<leader>tn", function() node:toggle() end, { noremap = true, silent = true, desc = "Toggle node REPL" })
        vim.keymap.set("n", "<leader>tp", function() python:toggle() end, { noremap = true, silent = true, desc = "Toggle python REPL" })

        -- Terminal navigation
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        end

        -- Auto-command to set terminal keymaps when terminal is opened
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
}