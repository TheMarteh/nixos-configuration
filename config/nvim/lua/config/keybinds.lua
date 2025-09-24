-- Keybinds
vim.g.mapleader = " "

-- easy reload without exiting (n)vim
vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

-- <leader>cd om terug te gaan naar de treeview
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
