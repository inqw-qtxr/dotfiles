return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = ":call mkdp#util#install()", -- Updated installation method
    init = function()
        -- Set default markdown preview settings
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_command_for_global = 0
        vim.g.mkdp_open_to_the_world = 0
        vim.g.mkdp_browser = ""  -- Use default browser
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_page_title = '「${name}」'
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
        -- Add keymaps for markdown preview
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>",
                    { noremap = true, silent = true, buffer = true, desc = "Toggle Markdown Preview" })
            end,
        })
    end,
}