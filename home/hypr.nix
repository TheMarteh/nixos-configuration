{ config, ... }:

let
  hyprConfig = "${config.home.homeDirectory}/nixos-configuration/config/hypr";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  # hyprland.lua doet require() op deze buurbestanden; Hyprland zet package.path
  # op de configmap. De kleuren komen niet uit een buurbestand maar uit
  # ~/.config/current-theme/hypr.lua, dat looknfeel.lua met dofile() ophaalt.
  luaFiles = [
    "hyprland"
    "monitors"
    "looknfeel"
    "input"
    "keybindings"
    "windowrules"
  ];
in
{
  xdg.configFile =
    builtins.listToAttrs (
      map (name: {
        name = "hypr/${name}.lua";
        value.source = link "${hyprConfig}/${name}.lua";
      }) luaFiles
    )
    // {
      # hyprlock.conf staat bewust niet in luaFiles: die wordt samen met
      # hypridle in home/idle.nix gelinkt.
      #
      # Mappen blijven als geheel gelinkt; daar zit niets gegenereerds in.
      "hypr/scripts".source = link "${hyprConfig}/scripts";
      "hypr/wallpapers".source = link "${hyprConfig}/wallpapers";
    };
}
