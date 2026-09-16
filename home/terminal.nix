{ pkgs, pkgs-unstable, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "CommitMono Nerd Font Mono";
        };
        size = 12.0;
      };
    };
  };

  home.packages = with pkgs; [
    kitty

    # CLI tools
    ripgrep
    fd
    unzip
    neofetch
    pkgs-unstable.btop-cuda
    tree
    bat

    # bash tools
    bats # for testing shell scripts
    gum # for fancy shell UIs
  ];
}
