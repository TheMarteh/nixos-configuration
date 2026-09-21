# Centrale kleuren- en fontdefinitie voor het hele systeem.
#
# Bewust een platte attrset en geen NixOS-optie: zo kan zowel een module uit
# modules/nixos als een home-manager module hem lezen met `import ../../theme`,
# zonder dat er een option-tree omheen moet.
#
# Kleuren staan zonder '#' opgeslagen, omdat elke consumer een andere notatie
# wil: CSS wil #rrggbb, Hyprland wil rgba(rrggbbaa). Gebruik de helpers onderaan.
#
# De theming valt in twee lagen uiteen:
#
#   Laag A -- te wisselen zonder rebuild. home/theme.nix bouwt élk palet uit
#     `palettes` via theme/render.nix naar ~/.config/themes/<naam>/, en
#     `theme-set` verzet de symlink ~/.config/current-theme. waybar, rofi,
#     swaync, Hyprland en alacritty importeren uit die symlink.
#
#   Laag B -- vastgezet bij de build. De virtuele console (het palet wordt uit
#     de initrd gezet) en tuigreet (draait als user `greeter` en kan ~/.config
#     van steal niet lezen). Die gebruiken `default` hieronder, dus na een
#     themawissel volgt het inlogscherm pas na de eerstvolgende `nrs`.
rec {
  palettes = {
    catppuccin-mocha = import ./palettes/catppuccin-mocha.nix;
    tokyo-night = import ./palettes/tokyo-night.nix;
    gruvbox-dark = import ./palettes/gruvbox-dark.nix;
    nord = import ./palettes/nord.nix;
  };

  # Het palet van laag B, en tegelijk waar een verse installatie mee begint.
  default = palettes.catppuccin-mocha;

  # Laag B leest deze rechtstreeks (modules/nixos/console.nix en greetd.nix
  # deden dat al voordat er meerdere palettes waren; dat blijft zo werken).
  inherit (default)
    name
    variant
    colors
    accent
    accentAlt
    ansi
    ;

  font = {
    mono = "CommitMono Nerd Font";
    # Moet overeenkomen met wat modules/nixos/fonts.nix installeert.
    size = 14;
  };

  radius = 12;

  # #rrggbb, voor CSS en GTK. Alpha doe je in GTK4-CSS met alpha(kleur, 0.5).
  hex = c: "#${c}";

  # rgba(rrggbbaa), de notatie die Hyprland verwacht.
  rgba = c: a: "rgba(${c}${a})";
}
