return {
    "github/copilot.vim",
    config = function()
        -- First, ensure we disable default tab mapping
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true

        -- Enable Copilot for specific filetypes
        vim.g.copilot_filetypes = {
            ["*"] = false,
            ["javascript"] = true,
            ["typescript"] = true,
            ["lua"] = true,
            ["rust"] = true,
            ["c"] = true,
            ["c++"] = true,
            ["go"] = true,
            ["python"] = true,
            ["ruby"] = true,
            ["dap-repl"] = false,
            ["dapui_watches"] = false,
            ["dapui_stacks"] = false,
            ["dapui_breakpoints"] = false,
            ["dapui_scopes"] = false,
        }

        -- Disable in specific buffers
        vim.g.copilot_disabled_buffer_types = {
            "TelescopePrompt",
            "TelescopeResults",
            "text",
            "markdown",
            "help",
        }

        -- Tab completion
        vim.keymap.set('i', '<Tab>', 'copilot#Accept("<CR>")', {
            expr = true,
            replace_keycodes = false,
            desc = "Accept copilot suggestion"
        })

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

