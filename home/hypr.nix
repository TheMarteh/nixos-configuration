{ config, ... }:

let
  theme = import ../theme;
  c = theme.colors;
  inherit (theme) rgba;

  hyprConfig = "${config.home.homeDirectory}/nixos-configuration/config/hypr";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  # hyprland.lua doet require() op deze buurbestanden; Hyprland zet package.path
  # op de configmap, dus theme.lua wordt daar ook gevonden.
  luaFiles = [
    "hyprland"
    "monitors"
    "looknfeel"
    "input"
    "keybindings"
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
      # Mappen blijven als geheel gelinkt; daar zit niets gegenereerds in.
      "hypr/scripts".source = link "${hyprConfig}/scripts";
      "hypr/wallpapers".source = link "${hyprConfig}/wallpapers";

      "hypr/theme.lua".text = ''
        -- Gegenereerd uit theme/default.nix -- pas dat bestand aan, niet dit.

        return {
            -- Actieve rand: het verloop sky -> teal
            active_border   = { "${rgba c.sky "ee"}", "${rgba c.teal "ee"}" },
            border_angle    = 45,
            inactive_border = "${rgba c.surface1 "aa"}",

            -- Schaduw wil een ARGB-integer, geen rgba()-string
            shadow          = 0xee${c.crust},
        }
      '';
    };
}
