return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Mason (optioneel)
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            
            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            -- Setup Mason
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {},
            })

            -- Capabilities voor autocompletion
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- LSP keybinds
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })

            -- ROSLYN LSP SETUP - Moderne API voor Neovim 0.11+
            -- Check eerst of roslyn-ls beschikbaar is
            local roslyn_cmd = vim.fn.exepath("Microsoft.CodeAnalysis.LanguageServer")
            
            if roslyn_cmd ~= "" then
                vim.lsp.config("roslyn", {
                    cmd = { roslyn_cmd },
                    filetypes = { "cs" },
                    root_markers = { "*.sln", "*.csproj", ".git" },
                    capabilities = capabilities,
                })
                
                -- Enable voor C# files
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = "cs",
                    callback = function()
                        vim.lsp.enable("roslyn")
                    end,
                })
            else
                vim.notify(
                    "Roslyn LSP not found. Install roslyn-ls via Nix.",
                    vim.log.levels.WARN
                )
            end

            -- Autocompletion setup
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
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
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            })

            -- Diagnostics configuratie
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    border = 'rounded',
                    source = 'always',
                },
            })

            -- Diagnostic symbols
            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },
}