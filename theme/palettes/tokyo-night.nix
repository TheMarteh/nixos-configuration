# Tokyo Night (de "night"-variant) -- https://github.com/folke/tokyonight.nvim
rec {
  name = "tokyo-night";
  label = "Tokyo Night";
  variant = "dark";

  colors = {
    base = "1a1b26";
    mantle = "16161e";
    crust = "13131a";

    surface0 = "292e42";
    surface1 = "3b4261";
    surface2 = "545c7e";

    overlay0 = "565f89";
    overlay1 = "737aa2";

    text = "c0caf5";
    subtext0 = "9aa5ce";
    subtext1 = "a9b1d6";

    blue = "7aa2f7";
    sky = "7dcfff";
    teal = "2ac3de";
    green = "9ece6a";
    mauve = "bb9af7";
    lavender = "9d7cd8";
    pink = "ff75a0";
    red = "f7768e";
    peach = "ff9e64";
    yellow = "e0af68";
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
    surface1
    red
    green
    yellow
    sky
    pink
    teal
    text
  ];

  wallpaper = "wallpaper2.jpg";

  # bat heeft geen Tokyo Night; TwoDark komt qua koelte het dichtst in de buurt.
  batTheme = "TwoDark";

  nvimColorscheme = "tokyonight-night";
}
