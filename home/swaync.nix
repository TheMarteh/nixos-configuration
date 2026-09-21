{ config, ... }:

let
  theme = import ../theme;
  c = theme.colors;
  inherit (theme) hex;

  swayncConfig = "${config.home.homeDirectory}/nixos-configuration/config/swaync";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # Zelfde opzet als waybar: config.json en style.css blijven out-of-store
  # symlinks, alleen theme.css komt uit Nix.
  xdg.configFile = {
    "swaync/config.json".source = link "${swayncConfig}/config.json";
    "swaync/style.css".source = link "${swayncConfig}/style.css";

    "swaync/theme.css".text = ''
      /* Gegenereerd uit theme/default.nix -- pas dat bestand aan, niet dit. */

      @define-color bg ${hex c.base};
      @define-color surface ${hex c.surface0};
      @define-color fg ${hex c.text};
      @define-color muted ${hex c.overlay1};
      @define-color accent ${hex c.blue};
      @define-color red ${hex c.red};

      * {
        font-family: "${theme.font.mono}";
      }
    '';
  };
}
