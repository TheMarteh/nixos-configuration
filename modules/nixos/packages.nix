{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    tmux
  ];

  # Laat ongepatchte (niet-Nix) binaries draaien
  programs.nix-ld.enable = true;
}
