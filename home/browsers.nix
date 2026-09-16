{ pkgs, zen-browser, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0; # 0 = dark, 1 = light
        "browser.theme.toolbar-theme" = 0;
      };
    };
  };

  home.packages = [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.vivaldi
  ];
}
