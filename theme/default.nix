# Centrale kleuren- en fontdefinitie voor het hele systeem.
#
# Bewust een platte attrset en geen NixOS-optie: zo kan zowel een module uit
# modules/nixos als een home-manager module hem lezen met `import ../../theme`,
# zonder dat er een option-tree omheen moet.
#
# Kleuren staan zonder '#' opgeslagen, omdat elke consumer een andere notatie
# wil: CSS wil #rrggbb, Hyprland wil rgba(rrggbbaa). Gebruik de helpers onderaan.
rec {
  name = "catppuccin-mocha";

  colors = {
    base = "1e1e2e";
    mantle = "181825";
    crust = "11111b";

    surface0 = "313244";
    surface1 = "45475a";
    surface2 = "585b70";

    overlay0 = "6c7086";
    overlay1 = "7f849c";

    text = "cdd6f4";
    subtext0 = "a6adc8";
    subtext1 = "bac2de";

    blue = "89b4fa";
    sky = "89dceb";
    teal = "94e2d5";
    green = "a6e3a1";
    mauve = "cba6f7";
    lavender = "b4befe";
    pink = "f5c2e7";
    red = "f38ba8";
    peach = "fab387";
    yellow = "f9e2af";
  };

  # Het accentverloop: dezelfde cyaan -> groen als de Hyprland-vensterranden.
  accent = colors.sky;
  accentAlt = colors.teal;

  font = {
    mono = "CommitMono Nerd Font";
    # Moet overeenkomen met wat modules/nixos/fonts.nix installeert.
    size = 14;
  };

  radius = 12;

  # De 16 kleuren van de virtuele console, in volgorde 0..15. Twee bewuste
  # afwijkingen van Catppuccin's eigen terminal-mapping: kleur 0 is op de Linux
  # console ook de achtergrond, dus daar hoort base en niet surface1; en kleur 15
  # is text, anders is "bright white" donkerder dan gewoon wit.
  ansi = with colors; [
    base # 0  zwart / achtergrond
    red # 1
    green # 2
    yellow # 3
    blue # 4
    mauve # 5  magenta
    teal # 6  cyaan
    subtext1 # 7  wit
    surface1 # 8  fel zwart
    red # 9
    green # 10
    yellow # 11
    sky # 12 fel blauw
    pink # 13 fel magenta
    teal # 14 fel cyaan
    text # 15 fel wit
  ];

  # #rrggbb, voor CSS en GTK. Alpha doe je in GTK4-CSS met alpha(kleur, 0.5).
  hex = c: "#${c}";

  # rgba(rrggbbaa), de notatie die Hyprland verwacht.
  rgba = c: a: "rgba(${c}${a})";
}
