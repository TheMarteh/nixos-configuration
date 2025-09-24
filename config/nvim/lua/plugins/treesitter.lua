return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                -- syntax highlighting
                highlight = { enable = true },

                -- indentation
                indent = { enable = true },

                -- auto install some parsers
                ensure_installed = {
                    "json",
                    "lua",
                    "typescript",
                    "markdown",
                    "c_sharp",
                    "yaml",
                    "css",
                    "bash",
                    "markdown_inline",
                    "vim",
                    "vimdoc",
                    "dockerfile",
                    "gitignore",
                    "tsx",
                    "javascript",
                },

                -- auto-install uit, want treesitter-cli is niet geinstalleerd
                auto_install = false,
            })
        end
    },
}
