# Catppuccin Mocha -- https://github.com/catppuccin/catppuccin
#
# Alle palettes hebben exact dezelfde sleutels; theme/render.nix rekent daarop.
# De namen komen van Catppuccin, maar zijn hier puur semantisch bedoeld:
# base/mantle/crust van donker naar donkerder, surface* voor vlakken,
# overlay* voor randen en gedempte tekst, text/subtext* voor tekst.
rec {
  name = "catppuccin-mocha";
  label = "Catppuccin Mocha";
  variant = "dark";

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

  # De 16 kleuren van de virtuele console en van alacritty, in volgorde 0..15.
  # Twee bewuste afwijkingen van Catppuccin's eigen terminal-mapping: kleur 0 is
  # op de Linux console ook de achtergrond, dus daar hoort base en niet
  # surface1; en kleur 15 is text, anders is "bright white" donkerder dan
  # gewoon wit.
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

  wallpaper = "wallpaper1.jpg";

  # bat kent alleen zijn eigen ingebouwde themanamen (`bat --list-themes`).
  batTheme = "Catppuccin Mocha";

  # Colorscheme-naam zoals de nvim-plugin hem registreert (zie home/theme.nix).
  nvimColorscheme = "catppuccin-mocha";
}
