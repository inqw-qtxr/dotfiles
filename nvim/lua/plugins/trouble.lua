return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local trouble = require("trouble")
        local keymap = vim.keymap.set

        -- Default keymap options
        local opts = {
            silent = true,
            noremap = true,
        }

        -- Trouble configuration
        trouble.setup({
            position = "bottom",
            height = 10,
            icons = true,
            mode = "workspace_diagnostics",
            fold_open = "",
            fold_closed = "",
            group = true,
            padding = true,
            auto_close = true,
            auto_preview = true,
            use_diagnostic_signs = true,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = "",
            },
        })

        -- Keymaps configuration
        local mappings = {
            ["<leader>xx"] = { "<cmd>TroubleToggle<cr>", "Toggle trouble" },
            ["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
            ["<leader>xd"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
            ["<leader>xl"] = { "<cmd>TroubleToggle loclist<cr>", "Location list" },
            ["<leader>xq"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix list" },
        }

        -- Apply keymaps
        for key, mapping in pairs(mappings) do
            keymap("n", key, mapping[1], vim.tbl_extend("force", opts, { desc = mapping[2] }))
        end
    end,
}