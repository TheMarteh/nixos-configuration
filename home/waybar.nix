{ config, ... }:

let
  theme = import ../theme;
  c = theme.colors;
  inherit (theme) hex;

  waybarConfig = "${config.home.homeDirectory}/nixos-configuration/config/waybar";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # config.jsonc en style.css blijven out-of-store symlinks, zodat lay-out en
  # regels live aan te passen zijn zonder rebuild. Alleen theme.css komt uit
  # Nix; style.css importeert die bovenaan.
  xdg.configFile = {
    "waybar/config.jsonc".source = link "${waybarConfig}/config.jsonc";
    "waybar/style.css".source = link "${waybarConfig}/style.css";

    "waybar/theme.css".text = ''
      /* Gegenereerd uit theme/default.nix -- pas dat bestand aan, niet dit. */

      @define-color bg ${hex c.base};
      @define-color bg-alt ${hex c.mantle};
      @define-color surface ${hex c.surface0};
      @define-color surface-alt ${hex c.surface1};

      @define-color fg ${hex c.text};
      @define-color fg-dim ${hex c.subtext0};
      @define-color muted ${hex c.overlay1};

      @define-color accent ${hex theme.accent};
      @define-color accent-alt ${hex theme.accentAlt};

      @define-color blue ${hex c.blue};
      @define-color mauve ${hex c.mauve};
      @define-color green ${hex c.green};
      @define-color yellow ${hex c.yellow};
      @define-color peach ${hex c.peach};
      @define-color red ${hex c.red};

      * {
        font-family: "${theme.font.mono}", monospace;
      }
    '';
  };
}
