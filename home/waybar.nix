{ config, ... }:

let
  waybarConfig = "${config.home.homeDirectory}/nixos-configuration/config/waybar";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # Beide bestanden blijven out-of-store symlinks, zodat lay-out en regels live
  # aan te passen zijn zonder rebuild. De kleuren komen uit
  # ~/.config/current-theme/waybar.css, waar style.css bovenaan een @import op
  # doet; zie home/theme.nix.
  xdg.configFile = {
    "waybar/config.jsonc".source = link "${waybarConfig}/config.jsonc";
    "waybar/style.css".source = link "${waybarConfig}/style.css";
  };
}
