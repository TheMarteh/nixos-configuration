{ config, pkgs, pkgs-unstable, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    hypr = "hypr";
    waybar = "waybar";
  };
in

{
  home.username = "steal";
  home.homeDirectory = "/home/steal";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.git = { 
    enable = true;
    userName = "TheMarteh";
    userEmail = "martijnfs@me.com";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
        };
        size = 16.0;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.docker-cli.enable = true;
  programs.lazydocker.enable = true;
  
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use NixOS, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-configuration#nixos-steal";
    };
  };

  programs.firefox.enable = true;


  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    # Development tools
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc

    # Terminal tools
    neofetch
    btop
    tree

    # GUI apps
    vscode
    obsidian
    _1password-cli
    _1password-gui
    bolt-launcher # osrs launcher
    vivaldi
    kdePackages.dolphin
    pkgs-unstable.whatsapp-electron

    # Wayland/Hyprland tools
    kitty
    wofi
    rofi
    waybar
  ];

  services.swww = {
    enable = true;
    package = pkgs-unstable.swww;
  };
}
