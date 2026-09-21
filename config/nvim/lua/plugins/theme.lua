-- De colorscheme volgt het actieve palet. `theme-set` verzet
-- ~/.config/current-theme en de nvim.lua daarin geeft alleen de naam door; de
-- colorschemes zelf zijn gewone nvim-plugins. Zie theme/render.nix.
--
-- Alleen nieuwe nvim-instanties pakken een wissel op; een draaiende sessie
-- verandert niet mee.

local function colorscheme()
  local ok, palette = pcall(dofile, os.getenv("HOME") .. "/.config/current-theme/nvim.lua")
  if ok and type(palette) == "table" and palette.colorscheme then
    return palette.colorscheme
  end
  -- Nog geen theme-set gedraaid: val terug op wat LazyVim zelf meelevert.
  return "tokyonight"
end

return {
  -- catppuccin en tokyonight komen al met LazyVim mee, deze twee niet.
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = colorscheme() },
  },
}
