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

  # # VSCode met .NET support
  # programs.vscode = {
  #   enable = true;
  #   # Gebruik FHS wrapper voor betere .NET compatibiliteit
  #   package = pkgs.vscode.fhsWithPackages (ps: with ps; [
  #     dotnet-sdk_9
  #     zlib
  #     openssl
  #     icu
  #   ]);
  #   extensions = with pkgs.vscode-extensions; [
  #     ms-dotnettools.csharp
  #     ms-dotnettools.csdevkit
  #     ms-dotnettools.vscode-dotnet-runtime
  #   ];
  #   userSettings = {
  #     # .NET specifieke settings
  #     "dotnet.dotnetPath" = "dotnet";  # Werkt nu via FHS
  #     "omnisharp.useModernNet" = true;
  #   };

  #   mutableExtensionsDir = true;
  # };
  # # Environment variabelen voor .NET
  # home.sessionVariables = {
  #   DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
  #   DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  # };
  # home.sessionPath = [
  #   "${pkgs.dotnet-sdk_9}/bin"
  # ];

  home.packages = with pkgs; [
    # Development tools
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    dotnet-sdk_9
    # Populaire .NET tools
    dotnet-ef        # Entity Framework CLI

    # Terminal tools
    neofetch
    btop
    tree

    # Key wallet
    kdePackages.kwallet
    kdePackages.kwalletmanager  # GUI om wallet te beheren

    # GUI apps
    obsidian # note-taking app
    _1password-cli 
    _1password-gui 
    bolt-launcher # osrs launcher
    vivaldi # web browser
    kdePackages.dolphin # File manager
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    jetbrains.rider # .NET IDE
    vscode # Code editor

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

  # KDE Wallet service
  systemd.user.services.kwallet = {
    Unit = {
      Description = "KDE Wallet Service";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Pinentry voor wachtwoord prompts
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
