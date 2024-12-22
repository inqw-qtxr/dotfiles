return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    keys = {
        -- Define keymaps in a structured way
        {
            "<leader>mp",
            "<cmd>MarkdownPreviewToggle<cr>",
            ft = "markdown",
            desc = "Toggle Markdown Preview"
        },
        {
            "<leader>ms",
            "<cmd>MarkdownPreviewStop<cr>",
            ft = "markdown",
            desc = "Stop Markdown Preview"
        },
    },
    opts = {
        -- Store all options in a single table for better organization
        auto_start = 0,
        auto_close = 1,
        refresh_slow = 0,
        command_for_global = 0,
        open_to_the_world = 0,
        open_ip = "127.0.0.1",
        browser = "",
        echo_preview_url = 1,
        port = "8888",
        page_title = '「${name}」',
        filetypes = { "markdown" },
        
        preview_options = {
            mkit = {},
            katex = {}, -- KaTeX for math rendering
            uml = {},   -- PlantUML for UML diagrams
            maid = {},  -- Mermaid for diagrams
            disable_sync_scroll = 0,
            sync_scroll_type = "middle",
            hide_yaml_meta = 1,
            sequence_diagrams = {},
            flowchart_diagrams = {},
            content_editable = false,
            disable_filename = 0,
            toc = {
                -- TOC options
                marker = "<!-- toc -->",
                levels = "1-3",
                cyclic = true,
            },
        },
        
        -- CSS customization
        markdown_css = vim.fn.expand("~/.config/nvim/markdown-preview.css"),
        highlight_css = vim.fn.expand("~/.config/nvim/markdown-highlight.css"),
        
        -- Theme settings
        theme = "dark",
        
        -- Custom CSS
        preview_css = [[
            .markdown-body {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
            }
        ]],
    },
    init = function()
        -- Set up markdown-specific settings
        local group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })
        
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "markdown",
            callback = function()
                -- Editor settings
                vim.opt_local.wrap = true
                vim.opt_local.spell = true
                vim.opt_local.conceallevel = 2
                vim.opt_local.textwidth = 80
                vim.opt_local.formatoptions = vim.opt_local.formatoptions
                    + "n"   -- Recognize numbered lists
                    + "r"   -- Continue comments on <Enter>
                    + "t"   -- Auto-wrap text using textwidth
                    + "q"   -- Allow formatting of comments with gq
                
                -- Optional: Enable markdown folding
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "markdown#fold#expr()"
                vim.opt_local.foldtext = "markdown#fold#text()"
            end,
        })
    end,
    config = function(_, opts)
        -- Apply options from opts table
        for k, v in pairs(opts) do
            if k ~= "preview_options" then
                vim.g["mkdp_" .. k] = v
            end
        end
        vim.g.mkdp_preview_options = opts.preview_options
        
        -- Add custom preview template
        vim.g.mkdp_markdown_css = opts.markdown_css
        vim.g.mkdp_highlight_css = opts.highlight_css
        vim.g.mkdp_theme = opts.theme
        
        -- Set up custom preview template
        vim.g.mkdp_preview_css = opts.preview_css
        
        -- Optional: Add commands for common markdown tasks
        vim.api.nvim_create_user_command("MarkdownTOC", function()
            vim.cmd("normal! o<!-- toc -->\n<!-- tocstop -->")
        end, { desc = "Insert TOC markers" })
        
        vim.api.nvim_create_user_command("MarkdownCreateLink", function()
            local text = vim.fn.expand("<cword>")
            local link = vim.fn.input("Enter link URL: ")
            vim.cmd("normal! ciw[" .. text .. "](" .. link .. ")")
        end, { desc = "Create markdown link from word under cursor" })
    end,
}