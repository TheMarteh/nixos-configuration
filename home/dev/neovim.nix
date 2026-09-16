{ pkgs, ... }:

{
  # Neovim config zelf staat in ./config/nvim (zie dotfiles.nix)
  home.packages = with pkgs; [
    neovim
    gcc
    tree-sitter
    nodejs
    python3

    # Nix LSP + formatter
    nil
    nixpkgs-fmt
  ];
}
