# Gruvbox Dark (hard) -- https://github.com/morhetz/gruvbox
#
# Let op: Gruvbox is warm en heeft geen cyaan accent zoals de andere drie. De
# vensterrand wordt hier dus een aqua -> groen verloop in plaats van cyaan.
rec {
  name = "gruvbox-dark";
  label = "Gruvbox Dark";
  variant = "dark";

  colors = {
    base = "1d2021";
    mantle = "141617";
    crust = "0d0e0f";

    surface0 = "32302f";
    surface1 = "3c3836";
    surface2 = "504945";

    overlay0 = "665c54";
    overlay1 = "7c6f64";

    text = "ebdbb2";
    subtext0 = "bdae93";
    subtext1 = "d5c4a1";

    blue = "83a598";
    sky = "8ec07c";
    teal = "689d6a";
    green = "b8bb26";
    mauve = "d3869b";
    lavender = "bdae93";
    pink = "d3869b";
    red = "fb4934";
    peach = "fe8019";
    yellow = "fabd2f";
  };

  accent = colors.sky;
  accentAlt = colors.teal;

  ansi = with colors; [
    base
    red
    green
    yellow
    blue
    mauve
    teal
    subtext1
    surface2
    red
    green
    yellow
    sky
    pink
    sky
    text
  ];

  wallpaper = "wallpaper1.jpg";

  batTheme = "gruvbox-dark";

  nvimColorscheme = "gruvbox";
}
