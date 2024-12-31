return {
    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter", "CmdlineEnter" }, -- Add CmdlineEnter for command line support
        opts = { 
            check_ts = true,
            disable_filetype = { "TelescopePrompt", "vim" }, -- Add vim filetype to disabled
            enable_check_bracket_line = true, -- Prevent adding pairs if it would create unbalanced brackets
            ignored_next_char = "[%w%.]", -- Don't add pairs if the next char is alphanumeric
        },
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = { "InsertEnter", "LspAttach" }, -- Add LspAttach for better integration
        config = function()
            -- Expanded filetype support
            vim.g.copilot_filetypes = {
                ["*"] = true,
                ["markdown"] = true,
                ["yaml"] = true,
                ["json"] = true,
                ["terraform"] = true,
                ["dockerfile"] = true,
            }

            -- Enhanced keymaps with better ergonomics
            vim.g.copilot_no_tab_map = true
            local opts = { silent = true, expr = true, replace_keycodes = false }
            vim.keymap.set("i", "<C-j>", 'copilot#Accept("<CR>")', opts)
            vim.keymap.set("i", "<M-]>", 'copilot#Next()', opts)
            vim.keymap.set("i", "<M-[>", 'copilot#Previous()', opts)
            vim.keymap.set("i", "<M-\\>", 'copilot#Dismiss()', opts)

            -- Additional Copilot settings
            vim.g.copilot_enabled = true
            vim.g.copilot_node_command = "node" -- Specify node version explicitly
        end,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" }, -- More specific events
        opts = { -- Use opts instead of config
            padding = true,
            sticky = true,
            ignore = "^$", -- Ignore empty lines
            toggler = {
                line = "gcc",
                block = "gbc",
            },
            opleader = {
                line = "gc",
                block = "gb",
            },
            extra = {
                above = "gcO",
                below = "gco",
                eol = "gcA",
            },
            mappings = {
                basic = true,
                extra = true,
            },
        },
    },

    -- Word toggler with expanded functionality
    {
        "nguyenvukhang/nvim-toggler",
        keys = {
            { "<leader>i", desc = "Toggle word under cursor" }
        },
        opts = { 
            inverses = {
                ['true'] = 'false',
                ['yes'] = 'no',
                ['on'] = 'off',
                ['left'] = 'right',
                ['up'] = 'down',
                ['enable'] = 'disable',
                ['enabled'] = 'disabled',
                ['success'] = 'failure',
                ['open'] = 'close',
                ['development'] = 'production',
                ['min'] = 'max',
                ['minimum'] = 'maximum',
                ['dark'] = 'light',
                ['before'] = 'after',
                ['dev'] = 'prod',
            },
            remove_default_keybinds = true,
            create_commands = true,
        },
        config = function(_, opts)
            require('nvim-toggler').setup(opts)
            vim.keymap.set({'n', 'v'}, '<leader>i', require('nvim-toggler').toggle, 
                { desc = "Toggle word under cursor" })
        end,
    },
}