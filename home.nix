{ config, pkgs, pkgs-unstable, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # qtile = "qtile";
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

  # Mapping van dotfiles in ./config naar $HOME/.config
  xdg.configFile = builtins.mapAttrs
  (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  })
  configs;


  # === Environment variables ===
  home.sessionVariables = {
    # GTK
    GTK_THEME = "Adwaita:dark";
    
    # Qt
    QT_QPA_PLATFORMTHEME = "adwaita";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    
    # .NET
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";

    # Dit zou helpen bij Electron apps op Wayland
    ELECTRON_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Voor Flutter apps op Wayland
    ANDROID_EMULATOR_USE_SYSTEM_LIBS = "1";
  };

  
  # === Default theming ===
  # GTK Theme (voor Firefox, GNOME apps, etc.)
  gtk = {
    enable = true;
    
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt Theme (voor Dolphin, Rider, KDE apps)
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };


  # === Services ===
  # Swww service voor wallpapers en compositing
  services.swww = {
    enable = true;
    package = pkgs-unstable.swww;
  };

  # Pinentry voor wachtwoord prompts
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
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


  # === Programma configuraties ===
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
          family = "CommitMono Nerd Font Mono";
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
      nfu = "nix flake update --flake ~/nixos-configuration";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;  # 0 = dark, 1 = light
        "browser.theme.toolbar-theme" = 0;
      };
    };
  };

  # VSCode met .NET ondersteuning
  programs.vscode = {
    enable = true;
    # Gebruik FHS wrapper voor betere .NET compatibiliteit
    package = pkgs-unstable.vscode.fhsWithPackages (ps: with ps; [
      dotnet-sdk_9
      zlib
      openssl
      icu
    ]);
    
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        ms-dotnettools.vscode-dotnet-runtime
      ];
      # Removed user settings because it clashed
      # with the vscode sync'ed settings.
      # userSettings = {
      #   # .NET specifieke settings
      #   "omnisharp.useModernNet" = true;
      #   # Smart commit
      #   "git.confirmSync" = false;
      #   "git.enableSmartCommit" = true;
      # };
    };
    mutableExtensionsDir = true;
  };

  # === Geïnstalleerde pakketten ===
  home.packages = with pkgs; [
    # Development tools
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    cmake
    dotnet-sdk_9
    dotnet-ef        # Entity Framework CLI
    flutter
    ninja

    # Misc
    blueberry # bluetooth management tool

    # Terminal tools
    neofetch
    btop
    tree

    # Key wallet
    kdePackages.kwallet
    kdePackages.kwalletmanager  # GUI om wallet te beheren

    # GUI apps
    obsidian # note-taking app
    _1password-cli # password manager CLI
    _1password-gui # password manager GUI
    pkgs-unstable.bolt-launcher # osrs launcher
    vivaldi # web browser
    kdePackages.dolphin # File manager
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    jetbrains.rider # .NET IDE
    android-studio # Android development IDE
    android-tools # ADB en Fastboot tools
    # pkgs-unstable.vscode # Code editor (geen FHS wrapper)

    # Wayland/Hyprland tools
    kitty
    wofi
    rofi
    waybar

    # Theme packages
    adwaita-qt
    adwaita-qt6
    gnome-themes-extra
    adwaita-icon-theme
  ];
}
