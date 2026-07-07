{ config, pkgs, pkgs-unstable, zen-browser, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # qtile = "qtile";
    nvim = "nvim";
    hypr = "hypr";
    waybar = "waybar";
    swaync = "swaync";
  };
  androidEmu = pkgs.androidenv.emulateApp {
    name = "emulate-MyAndroidApp";
    platformVersion = "36";
    abiVersion = "x86_64";
    systemImageType = "google_apis_playstore";
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
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";

    # Java/AWT apps under XWayland (e.g. RuneLite via Bolt)
    _JAVA_AWT_WM_NONREPARENTING = "1"; # fixes blank/grey windows & resize glitches on tiling WMs
 
    # Dit zou helpen bij Electron apps op Wayland
    ELECTRON_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Voor Flutter apps op Wayland
    ANDROID_EMULATOR_USE_SYSTEM_LIBS = "1";
    QT_QPA_PLATFORM = "xcb";

    # Flutter Linux build dependencies (pkg-config paths)
    PKG_CONFIG_PATH = "${pkgs.libsecret.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
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


  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-cuda;
  };



  # === Programma configuraties ===
  programs.git = { 
    enable = true;
    settings.user = {
        name = "TheMarteh";
        email = "martijnfs@me.com";
    };
  };

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

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode.fhsWithPackages (ps: with ps; [
      # .NET SDK and runtime for debugging
      pkgs-unstable.dotnet-sdk_10

      # Required for vsdbg (the .NET debugger)
      icu
      openssl
      zlib
      curl

      # Common build dependencies
      gcc
      glibc

      # Flutter development
      flutter
      cmake
      ninja
      pkg-config
      gtk3
      glib
      libsecret
      pcre2
      xz
    ]);

    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      ms-dotnettools.vscode-dotnet-runtime
    ];
    mutableExtensionsDir = true;
  };

  # === Geïnstalleerde pakketten ===
  home.packages = with pkgs; [
    # Development tools
    neovim
    gcc
    tree-sitter
    ripgrep
    fd
    nil
    nixpkgs-fmt
    nodejs
    cmake
    pkgs-unstable.dotnet-sdk_10
    roslyn-ls
    omnisharp-roslyn
    pkgs-unstable.csharpier   # C# code formatter
    dotnet-ef        # Entity Framework CLI
    flutter
    ninja
    python3
    pkgs-unstable.claude-code
    libsecret
    pkg-config
    unzip

    # bash tools
    bats # for testing shell scripts
    gum # for fancy shell UIs


    # Misc
    blueberry # bluetooth management tool

    # Terminal tools
    neofetch
    pkgs-unstable.btop-cuda
    tree
    lazygit
    lazydocker
    bat

    # Key wallet
    kdePackages.kwallet
    kdePackages.kwalletmanager  # GUI om wallet te beheren

    # GUI apps
    obsidian # note-taking app
    _1password-cli # password manager CLI
    _1password-gui # password manager GUI
    pkgs-unstable.bolt-launcher # osrs launcher
    zen-browser.packages.${pkgs.system}.default # Zen browser
    vivaldi # web browser
    kdePackages.dolphin # File manager
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    jetbrains.rider # .NET IDE
    android-studio # Android development IDE
    android-tools # ADB en Fastboot tools
    android-studio-tools # Android emulator en cli shizzle
    androidEmu # Android emulator instance
    yaak # API testing tool
    # pkgs-unstable.vscode # Code editor (geen FHS wrapper)
    zed-editor # Alternatieve code editor
    discord # Chat app

    # 3d print software
    cura-appimage

    # Wayland/Hyprland tools
    kitty
    wofi
    rofi
    waybar
    brightnessctl
    playerctl
    grim
    slurp
    swaynotificationcenter
    libnotify
    wl-clipboard
    hyprland

    # Theme packages
    adwaita-qt
    adwaita-qt6
    gnome-themes-extra
    adwaita-icon-theme
  ];
}
