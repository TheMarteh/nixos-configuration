{ config, ... }:

let
  swayncConfig = "${config.home.homeDirectory}/nixos-configuration/config/swaync";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # Zelfde opzet als waybar: out-of-store symlinks, kleuren via een @import op
  # ~/.config/current-theme/swaync.css (zie home/theme.nix).
  xdg.configFile = {
    "swaync/config.json".source = link "${swayncConfig}/config.json";
    "swaync/style.css".source = link "${swayncConfig}/style.css";
  };
}
