{ pkgs, ... }:

{
  # Neovim config zelf staat in ./config/nvim (zie dotfiles.nix)
  home.packages = with pkgs; [
    neovim
    gcc # compileert treesitter parsers
    tree-sitter
    nodejs
    python3

    # Nix LSP + formatter
    nil
    nixfmt
  ];
}
