{ config, pkgs, ... }:

let
  rofiConfig = "${config.home.homeDirectory}/nixos-configuration/config/rofi";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.packages = with pkgs; [
    # rofi 2.0 heeft de wayland-fork opgeslokt: dit draait native als
    # layer-shell-client, niet via XWayland.
    rofi
    # Alleen voor de launcher; rofi heeft een eigen icon-theme-instelling, dus
    # het GTK-icoonthema in theming.nix blijft Adwaita.
    papirus-icon-theme
  ];

  # config.rasi doet een @import op ~/.config/current-theme/rofi.rasi. Rofi lost
  # @import op vanaf de map van het includerende bestand en canonicaliseert de
  # symlink niet, dus het relatieve pad ../current-theme/ werkt.
  xdg.configFile."rofi/config.rasi".source = link "${rofiConfig}/config.rasi";
}
