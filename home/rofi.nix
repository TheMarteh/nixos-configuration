{ config, pkgs, ... }:

let
  theme = import ../theme;
  c = theme.colors;
  inherit (theme) hex;

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

  # Zelfde opzet als waybar en swaync: config.rasi blijft een out-of-store
  # symlink, theme.rasi komt uit Nix. Rofi lost @import op vanaf de map van het
  # includerende bestand en canonicaliseert de symlink niet, dus dat werkt.
  xdg.configFile = {
    "rofi/config.rasi".source = link "${rofiConfig}/config.rasi";

    "rofi/theme.rasi".text = ''
      /* Gegenereerd uit theme/default.nix -- pas dat bestand aan, niet dit. */

      * {
          bg:         ${hex c.base};
          /* ~85% dekkend, zodat de blur van de layer rule zichtbaar blijft */
          bg-alpha:   ${hex c.base}d9;
          surface:    ${hex c.surface0};
          fg:         ${hex c.text};
          fg-dim:     ${hex c.subtext0};
          muted:      ${hex c.overlay1};
          accent:     ${hex theme.accent};
          accent-alt: ${hex theme.accentAlt};
          red:        ${hex c.red};

          font: "${theme.font.mono} 12";

          /* Rofi's ingebouwde thema is Solarized-light en verwijst overal naar
             deze namen. Zonder ze te overschrijven wint bijvoorbeeld
             element normal.normal van een algemene element-regel en krijg je
             cremekleurige rijen. */
          background:                  transparent;
          foreground:                  @fg-dim;
          border-color:                @accent;
          separatorcolor:              @surface;

          normal-background:           transparent;
          normal-foreground:           @fg-dim;
          alternate-normal-background: transparent;
          alternate-normal-foreground: @fg-dim;
          selected-normal-background:  @surface;
          selected-normal-foreground:  @fg;

          active-background:           transparent;
          active-foreground:           @accent;
          alternate-active-background: transparent;
          alternate-active-foreground: @accent;
          selected-active-background:  @surface;
          selected-active-foreground:  @accent;

          urgent-background:           transparent;
          urgent-foreground:           @red;
          alternate-urgent-background: transparent;
          alternate-urgent-foreground: @red;
          selected-urgent-background:  @surface;
          selected-urgent-foreground:  @red;
      }
    '';
  };
}
