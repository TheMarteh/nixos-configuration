-- config options

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- indentation and tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

-- auto copy to system clipboard
vim.api.nvim_set_option("clipboard", "unnamedplus")
