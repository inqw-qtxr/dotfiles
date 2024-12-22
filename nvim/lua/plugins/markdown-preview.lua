return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    init = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_command_for_global = 0
        vim.g.mkdp_open_to_the_world = 0
        vim.g.mkdp_open_ip = "127.0.0.1"
        vim.g.mkdp_browser = ""
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_port = "8888"
        vim.g.mkdp_page_title = '「${name}」'
        vim.g.mkdp_filetypes = { "markdown" }
        
        vim.g.mkdp_preview_options = {
            mkit = {},
            katex = {},
            uml = {},
            maid = {},
            disable_sync_scroll = 0,
            sync_scroll_type = "middle",
            hide_yaml_meta = 1,
            sequence_diagrams = {},
            flowchart_diagrams = {},
            content_editable = false,
            disable_filename = 0,
            toc = {}
        }
        
        -- Enable markdown syntax for .md files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.opt_local.wrap = true
                vim.opt_local.spell = true
            end,
        })
    end,
    config = function()
        -- Add keymaps specifically for markdown files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>",
                    { noremap = true, silent = true, buffer = true, desc = "Toggle Markdown Preview" })
                vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>",
                    { noremap = true, silent = true, buffer = true, desc = "Stop Markdown Preview" })
            end,
        })
    end
}