return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "black", "ruff" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
                fish = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
        
        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            require("conform").format({
                async = true,
                lsp_fallback = true,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}