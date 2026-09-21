# Vertaalt één palet naar het configfragment van elke app.
#
# home/theme.nix roept dit aan voor élk palet uit theme/palettes/ en schrijft de
# uitkomst naar ~/.config/themes/<naam>/. `theme-set` verzet daarna alleen nog
# de symlink ~/.config/current-theme; er wordt niets herbouwd.
#
# Dit is de enige plek die weet hoe een palet er per formaat uitziet. Komt er
# een app bij, dan komt er hier een sleutel bij en verandert er verder niets.
{
  font,
  hex,
  rgba,
}:
palette:
let
  c = palette.colors;
  inherit (palette) accent accentAlt;

  # Eenregelig, want hij wordt in vier verschillende commentaarsyntaxen gebruikt.
  header = "Gegenereerd uit theme/render.nix voor palet ${palette.name} -- pas theme/palettes/${palette.name}.nix aan, niet dit bestand.";
in
{
  # ---- waybar -------------------------------------------------------------
  # GTK-CSS. config/waybar/style.css doet hier bovenaan een @import op.
  "waybar.css" = ''
    /* ${header} */

    @define-color bg ${hex c.base};
    @define-color bg-alt ${hex c.mantle};
    @define-color surface ${hex c.surface0};
    @define-color surface-alt ${hex c.surface1};

    @define-color fg ${hex c.text};
    @define-color fg-dim ${hex c.subtext0};
    @define-color muted ${hex c.overlay1};

    @define-color accent ${hex accent};
    @define-color accent-alt ${hex accentAlt};

    @define-color blue ${hex c.blue};
    @define-color mauve ${hex c.mauve};
    @define-color green ${hex c.green};
    @define-color yellow ${hex c.yellow};
    @define-color peach ${hex c.peach};
    @define-color red ${hex c.red};

    * {
      font-family: "${font.mono}", monospace;
    }
  '';

  # ---- swaync -------------------------------------------------------------
  # Ook GTK-CSS. Gebruikt bewust dezelfde `accent` als waybar en rofi; vóór de
  # centralisatie stond hier c.blue, waardoor het meldingencentrum als enige
  # uit de toon viel.
  "swaync.css" = ''
    /* ${header} */

    @define-color bg ${hex c.base};
    @define-color surface ${hex c.surface0};
    @define-color fg ${hex c.text};
    @define-color muted ${hex c.overlay1};
    @define-color accent ${hex accent};
    @define-color red ${hex c.red};

    * {
      font-family: "${font.mono}";
    }
  '';

  # ---- rofi ---------------------------------------------------------------
  "rofi.rasi" = ''
    /* ${header} */

    * {
        bg:         ${hex c.base};
        /* ~85% dekkend, zodat de blur van de layer rule zichtbaar blijft */
        bg-alpha:   ${hex c.base}d9;
        surface:    ${hex c.surface0};
        fg:         ${hex c.text};
        fg-dim:     ${hex c.subtext0};
        muted:      ${hex c.overlay1};
        accent:     ${hex accent};
        accent-alt: ${hex accentAlt};
        red:        ${hex c.red};

        font: "${font.mono} 12";

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

  # ---- Hyprland -----------------------------------------------------------
  # config/hypr/looknfeel.lua haalt dit op met dofile().
  "hypr.lua" = ''
    -- ${header}

    return {
        -- Actieve rand: het verloop accent -> accentAlt
        active_border   = { "${rgba accent "ee"}", "${rgba accentAlt "ee"}" },
        border_angle    = 45,
        inactive_border = "${rgba c.surface1 "aa"}",

        -- Schaduw wil een ARGB-integer, geen rgba()-string
        shadow          = 0xee${c.crust},
    }
  '';

  # ---- metadata -----------------------------------------------------------
  # Wordt door `theme-set` gesourcet, zodat dat script niets over de palettes
  # hoeft te weten behalve de mapnaam.
  "meta.sh" = ''
    # ${header}
    theme_name="${palette.name}"
    theme_label="${palette.label}"
    theme_variant="${palette.variant}"
    theme_wallpaper="${palette.wallpaper}"
    theme_bat="${palette.batTheme}"
    theme_nvim="${palette.nvimColorscheme}"
  '';
}
