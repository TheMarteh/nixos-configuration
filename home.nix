{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    hypr = "hypr";
  };
in

{
  home.username = "steal";
  home.homeDirectory = "/home/steal";
  programs.git = { 
    enable = true;
    userName = "TheMarteh";
    userEmail = "martijnfs@me.com";
  };
  programs.gh.enable = true;
  programs.gh.gitCredentialHelper.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use NixOS, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-configuration#nixos-steal";
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  wayland.windowManager.hyprland = {
  enable = true;
  # optioneel: extra config
  # settings = { ... };
  };

  # xdg.configFile."qtile" = {
  #   source = create_symlink "${dotfiles}/qtile/";
  #   recursive = true;
  # };

  # xdg.configFile."nvim" = {
  #   source = create_symlink "${dotfiles}/nvim/";
  #   recursive = true;
  # };
  # home.file.".config/alactritty".source = ./config/alactritty;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    neofetch
  ];
}
