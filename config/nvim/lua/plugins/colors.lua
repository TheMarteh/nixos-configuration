local function enable_transparancy()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

-- overal Catpuccin!
return {
    {

        "catppuccin/nvim",
        config = function()
            vim.cmd.colorscheme "catppuccin"
            enable_transparancy()
        end
    },
    {
        -- mooi lijntje voor onder aan mijn nvim
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            theme = "catppuccin",
        }
    }
}
