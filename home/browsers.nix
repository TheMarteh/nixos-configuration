{ pkgs, zen-browser, ... }:

{
  programs.firefox = {
    enable = true;

    # Blijf op het oude pad. De 26.05-default verhuist naar
    # $XDG_CONFIG_HOME/mozilla/firefox, maar verplaatst native messaging hosts
    # niet mee -- dat zou de 1Password-browserintegratie breken.
    configPath = ".mozilla/firefox";

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
