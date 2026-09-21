{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # De kleuren komen uit het actieve palet. Niet rechtstreeks uit
      # ~/.config/current-theme: alacritty kijkt met inotify naar het
      # gecanonicaliseerde pad, dus een verzette symlink zou pas in een nieuw
      # venster te zien zijn. `theme-set` zet hier een echte kopie neer; zie
      # home/theme.nix. Een ontbrekende import slaat alacritty over, dus vóór
      # de eerste theme-set valt hij gewoon terug op zijn eigen kleuren.
      general.import = [ "~/.config/alacritty/theme.toml" ];

      font = {
        normal = {
          family = "CommitMono Nerd Font Mono";
        };
        size = 12.0;
      };
    };
  };

  # bat kent alleen zijn eigen ingebouwde themanamen; welke dat is staat per
  # palet in bat.conf. Via deze variabele wijst bat naar de symlink, zodat een
  # themawissel meteen geldt zonder opnieuw in te loggen.
  home.sessionVariables.BAT_CONFIG_PATH = "${config.home.homeDirectory}/.config/current-theme/bat.conf";

  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    unzip
    fastfetch
    pkgs-unstable.btop-cuda
    tree
    bat

    # bash tools
    bats # for testing shell scripts
    gum # for fancy shell UIs
  ];
}
