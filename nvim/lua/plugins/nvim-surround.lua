return {
    "kylechui/nvim-surround",
    version = "*", -- Use latest stable version
    event = { "VeryLazy" },
    opts = {
        -- Keymaps configuration
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
        -- Custom surrounds configuration
        surrounds = {
            -- HTML/JSX tag surround
            ["t"] = {
                add = function()
                    local tag = vim.fn.input("Enter tag name: ")
                    return { { "<" .. tag .. ">" }, { "</" .. tag .. ">" } }
                end,
            },
            -- Markdown link surround
            ["l"] = {
                add = function()
                    local url = vim.fn.input("Enter URL: ")
                    return { { "[" }, { "](" .. url .. ")" } }
                end,
            },
            -- LaTeX math surround
            ["m"] = {
                add = { "\\(" , "\\)" },
            },
            -- LaTeX environment surround
            ["e"] = {
                add = function()
                    local env = vim.fn.input("Environment name: ")
                    return {
                        { "\\begin{" .. env .. "}\n    " },
                        { "\n\\end{" .. env .. "}" }
                    }
                end,
            },
            -- Comment surround
            ["/"] = {
                add = function()
                    local ft = vim.bo.filetype
                    local comment_string = vim.bo.commentstring
                    if comment_string:match("^/") then
                        return { "/* ", " */" }
                    else
                        return { comment_string:format(""), "" }
                    end
                end,
            },
            -- String template literal
            ["`"] = {
                add = { "`${", "}`" },
            },
        },
        -- Highlight configuration
        highlight = {
            duration = 250,  -- Highlight duration in milliseconds
        },
        -- Movement configuration
        move_cursor = "begin",  -- Move cursor to beginning of surround
        indent_lines = true,    -- Indent surrounded lines
    },
    -- Add aliases for common surround patterns
    config = function(_, opts)
        require("nvim-surround").setup(opts)

        -- Add useful autocommands for specific filetypes
        local group = vim.api.nvim_create_augroup("NvimSurroundConfig", { clear = true })
        
        -- HTML/JSX specific surrounds
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = { "html", "jsx", "tsx", "vue", "svelte" },
            callback = function()
                -- Add self-closing tag surround
                opts.surrounds["T"] = {
                    add = function()
                        local tag = vim.fn.input("Enter self-closing tag: ")
                        return { { "<" .. tag .. " />" }, { "" } }
                    end,
                }
            end,
        })

        -- Markdown specific surrounds
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "markdown",
            callback = function()
                -- Add code block surround
                opts.surrounds["c"] = {
                    add = function()
                        local lang = vim.fn.input("Language: ")
                        return {
                            { "```" .. lang .. "\n" },
                            { "\n```" }
                        }
                    end,
                }
            end,
        })

        -- Add user commands for common surround operations
        vim.api.nvim_create_user_command("SurroundAddTag", function()
            vim.cmd("normal yst")
            vim.fn.feedkeys("t", "n")
        end, { desc = "Surround with HTML/JSX tag" })

        vim.api.nvim_create_user_command("SurroundAddLink", function()
            vim.cmd("normal ysl")
        end, { desc = "Surround with Markdown link" })
    end,
}