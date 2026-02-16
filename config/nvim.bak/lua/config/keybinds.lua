-- Keybinds
vim.g.mapleader = " "

-- easy reload without exiting (n)vim
vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

-- <leader>cd om terug te gaan naar de treeview
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- Toggle diagnostics aan/uit
vim.keymap.set('n', '<leader>dt', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })