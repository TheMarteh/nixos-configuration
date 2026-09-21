# Nord -- https://www.nordtheme.com/
rec {
  name = "nord";
  label = "Nord";
  variant = "dark";

  colors = {
    base = "2e3440";
    mantle = "292e39";
    crust = "242933";

    surface0 = "3b4252";
    surface1 = "434c5e";
    surface2 = "4c566a";

    overlay0 = "616e88";
    overlay1 = "7b88a1";

    text = "eceff4";
    subtext0 = "d8dee9";
    subtext1 = "e5e9f0";

    blue = "81a1c1";
    sky = "88c0d0";
    teal = "8fbcbb";
    green = "a3be8c";
    mauve = "b48ead";
    lavender = "b0bec5";
    pink = "d3a0bc";
    red = "bf616a";
    peach = "d08770";
    yellow = "ebcb8b";
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
    subtext0
    surface2
    red
    green
    yellow
    sky
    pink
    teal
    text
  ];

  wallpaper = "wallpaper2.jpg";

  batTheme = "Nord";

  nvimColorscheme = "nord";
}
