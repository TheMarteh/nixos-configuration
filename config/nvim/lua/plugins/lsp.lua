return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
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
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {},
            })

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
                    
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
                    
                    -- Bevestiging dat LSP attached
                    print("LSP attached: " .. vim.lsp.get_client_by_id(ev.data.client_id).name)
                end,
            })

            -- ROSLYN LSP SETUP
            local roslyn_cmd = vim.fn.exepath("Microsoft.CodeAnalysis.LanguageServer")
            
            if roslyn_cmd ~= "" then
                -- Maak log directory
                local log_dir = vim.fn.stdpath("cache") .. "/roslyn"
                vim.fn.mkdir(log_dir, "p")
                
                -- Configureer Roslyn
                vim.lsp.config("roslyn", {
                    cmd = {
                        roslyn_cmd,
                        "--logLevel=Information",
                        "--extensionLogDirectory=" .. log_dir,
                    },
                    filetypes = { "cs" },
                    root_markers = { "*.sln", "*.csproj", ".git" },
                    capabilities = capabilities,
                    settings = {
                        ["csharp"] = {
                            -- Completion settings
                            ["completion"] = {
                                ["showCompletionItemKind"] = true,
                                ["showSnippets"] = true,
                            },
                            -- IntelliSense settings
                            ["intelliSense"] = {
                                ["enableImportCompletion"] = true,
                                ["enableMethodGroupCompletion"] = true,
                            },
                        },
                        ["csharp|inlay_hints"] = {
                            csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                            csharp_enable_inlay_hints_for_types = true,
                            dotnet_enable_inlay_hints_for_indexer_parameters = true,
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                            dotnet_enable_inlay_hints_for_other_parameters = true,
                            dotnet_enable_inlay_hints_for_parameters = true,
                        },
                        ["csharp|code_lens"] = {
                            dotnet_enable_references_code_lens = true,
                        },
                    },
                })
                
                -- BELANGRIJK: Enable voor ALLE C# buffers, niet alleen nieuwe
                vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                    pattern = "cs",
                    callback = function(args)
                        -- Check of LSP al draait voor deze buffer
                        local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "roslyn" })
                        if #clients == 0 then
                            vim.lsp.enable("roslyn")
                            print("Roslyn LSP started for " .. vim.fn.expand("%:t"))
                        end
                    end,
                })
                
                -- Start ook voor al geopende C# buffers
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                        if ft == "cs" then
                            vim.lsp.enable("roslyn")
                        end
                    end
                end
            else
                vim.notify(
                    "Roslyn LSP not found. Install roslyn-ls via Nix.",
                    vim.log.levels.ERROR
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
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert',  -- Toon altijd het menu
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
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'luasnip', priority = 750 },
                }, {
                    { name = 'buffer', priority = 500 },
                    { name = 'path', priority = 250 },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        -- Icons voor verschillende types
                        local kind_icons = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏌",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        }
                        
                        -- Icon + kind naam
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
                        
                        -- Source indicator
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        
                        return vim_item
                    end,
                },
            })

            -- Diagnostics configuratie - LIVE ERRORS
            vim.diagnostic.config({
                -- Toon errors inline als virtual text
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = '●',
                    -- Format de error messages
                    format = function(diagnostic)
                        if diagnostic.severity == vim.diagnostic.severity.ERROR then
                            return string.format("❌ %s", diagnostic.message)
                        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                            return string.format("⚠️  %s", diagnostic.message)
                        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                            return string.format("💡 %s", diagnostic.message)
                        else
                            return string.format("ℹ️  %s", diagnostic.message)
                        end
                    end,
                },
                -- Toon icons in de gutter (links van line numbers)
                signs = true,
                -- UPDATE TIJDENS HET TYPEN (dit is belangrijk!)
                update_in_insert = true,  -- ⬅️ VERANDER DIT NAAR true
                -- Underline de foute code
                underline = true,
                -- Sorteer op severity (errors eerst)
                severity_sort = true,
                -- Floating window settings
                float = {
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                    focusable = true,
                },
            })

            -- Diagnostic symbols
            local signs = { 
                Error = "󰅚 ", 
                Warn = "󰀪 ", 
                Hint = "󰌶 ", 
                Info = " " 
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },
}