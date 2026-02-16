return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            -- Capabilities
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Keybinds bij LSP attach
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local opts = { buffer = bufnr, silent = true }
                    
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
                    
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    print("✅ LSP attached: " .. client.name)
                end,
            })

            -- ROSLYN START - Simpel en direct
            local roslyn_cmd = vim.fn.exepath("Microsoft.CodeAnalysis.LanguageServer")
            
            if roslyn_cmd ~= "" then
                local log_dir = vim.fn.stdpath("cache") .. "/roslyn"
                vim.fn.mkdir(log_dir, "p")
                
                -- Start Roslyn voor C# files
                vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
                    pattern = "*.cs",
                    callback = function(ev)
                        -- Zoek naar .csproj of gebruik current dir
                        local root_dir = vim.fs.root(ev.buf, {".csproj", ".sln"}) or vim.fn.getcwd()
                        
                        vim.lsp.start({
                            name = "roslyn",
                            cmd = {
                                roslyn_cmd,
                                "--logLevel=Information",
                                "--extensionLogDirectory=" .. log_dir,
                                "--stdio",
                            },
                            root_dir = root_dir,
                            capabilities = capabilities,
                        })
                    end,
                })
            else
                vim.notify("⚠️  Roslyn not found", vim.log.levels.WARN)
            end

            -- Diagnostics config
            vim.diagnostic.config({
                virtual_text = {
                    spacing = 4,
                    prefix = '●',
                },
                signs = true,
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    border = 'rounded',
                    source = 'always',
                },
            })

            -- Diagnostic icons
            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
            end

            -- CMP Setup
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
            })
        end,
    },
}