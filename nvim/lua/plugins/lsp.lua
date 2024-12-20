return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Move your existing configuration here
        local lspconfig = require("lspconfig")

        -- Set up completion capabilities for nvim-cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        -- Default keybindings for LSP functionality
        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- LSP Navigation
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

            -- Workspace Management
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)

            -- LSP Actions
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>fF", function()
                vim.lsp.buf.format({ async = true })
            end, opts)

            -- Diagnostics
            vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)

            -- Set up autoformat on save if the client supports it
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end

        -- Lua
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        })

        -- Python - using pyright for types, ruff-lsp for linting
        lspconfig.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })

        lspconfig.ruff.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })

        -- TypeScript/JavaScript
        lspconfig.ts_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayPropertyDeclarationTypeHints = true,
                    },
                },
            },
        })

        -- Enhanced TypeScript/React setup
        lspconfig.eslint.setup({
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
                on_attach(client, bufnr)
            end,
            capabilities = capabilities,
        })

        -- Go
        lspconfig.gopls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
                silent = true,
                debounce_text_changes = 150,
            },
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                        unusedwrite = true,
                        useany = true,
                        nilness = true,
                        ST1000 = true, -- check for missing package documentation
                        ST1003 = true, -- check for proper naming
                        fieldalignment = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                    semanticTokens = true,
                    codelenses = {
                        gc_details = true,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        })

        -- Rust
        lspconfig.rust_analyzer.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    assist = {
                        importGranularity = "module",
                        importPrefix = "by_self",
                    },
                    cargo = { allFeatures = true },
                    checkOnSave = { command = "clippy" },
                    procMacro = { enable = true },
                },
            },
        })

        -- C/C++
        lspconfig.clangd.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
            },
        })

        -- Web dev
        local servers = {
            "html",
            "cssls",
            "jsonls",
            "yamlls",
            "bashls",
        }

        -- Basic setup for simple servers
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end
    end,
}
