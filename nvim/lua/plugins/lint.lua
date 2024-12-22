return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        
        lint.linters_by_ft = {
            python = { "ruff" },
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            zsh = { "shellcheck" },
            fish = { "shellcheck" },
            go = { "golangcilint" },
        }
        
        -- Create an autocmd group for linting
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        
        -- Create autocmd to trigger linting
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
        
        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}