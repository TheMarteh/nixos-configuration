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

  # De 16 console-kleuren als #rrggbb. alacritty krijgt exact dezelfde reeks als
  # de virtuele console, zodat een TTY en een terminalvenster niet verschillen.
  a = i: hex (builtins.elemAt palette.ansi i);

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

  # ---- alacritty ----------------------------------------------------------
  # home/terminal.nix laat alacritty dit importeren. Let op: alacritty ziet
  # inotify-events op het gecanonicaliseerde pad, dus een verzette symlink
  # merkt hij niet. `theme-set` kopieert dit fragment daarom naar
  # ~/.config/alacritty/theme.toml; zie home/theme.nix.
  "alacritty.toml" = ''
    # ${header}

    [colors.primary]
    background = "${hex c.base}"
    foreground = "${hex c.text}"
    dim_foreground = "${hex c.subtext0}"
    bright_foreground = "${hex c.text}"

    [colors.cursor]
    text = "${hex c.base}"
    cursor = "${hex accent}"

    [colors.selection]
    text = "${hex c.text}"
    background = "${hex c.surface1}"

    [colors.normal]
    black = "${a 0}"
    red = "${a 1}"
    green = "${a 2}"
    yellow = "${a 3}"
    blue = "${a 4}"
    magenta = "${a 5}"
    cyan = "${a 6}"
    white = "${a 7}"

    [colors.bright]
    black = "${a 8}"
    red = "${a 9}"
    green = "${a 10}"
    yellow = "${a 11}"
    blue = "${a 12}"
    magenta = "${a 13}"
    cyan = "${a 14}"
    white = "${a 15}"
  '';

  # ---- bat ----------------------------------------------------------------
  # bat kent alleen zijn eigen ingebouwde themanamen, dus hier geen kleuren maar
  # een keuze. Via BAT_CONFIG_PATH (home/terminal.nix) wijst bat naar dit
  # bestand in ~/.config/current-theme, zodat een wissel meteen geldt.
  "bat.conf" = ''
    # ${header}
    --theme=${palette.batTheme}
  '';

  # ---- btop ---------------------------------------------------------------
  # btop's eigen .theme-formaat: shell-achtige toewijzingen aan theme[...].
  # De *_start/_mid/_end-drietallen zijn verlopen voor de grafieken.
  #
  # Dit bestand belandt niet in de palet-map maar in ~/.config/btop/themes/,
  # want btop accepteert in color_theme alleen een naam en zoekt daar; zie
  # home/theme.nix.
  "btop.theme" = ''
    # ${header}

    theme[main_bg]="${hex c.base}"
    theme[main_fg]="${hex c.text}"
    theme[title]="${hex c.text}"
    theme[hi_fg]="${hex accent}"
    theme[selected_bg]="${hex c.surface1}"
    theme[selected_fg]="${hex c.text}"
    theme[inactive_fg]="${hex c.overlay0}"
    theme[graph_text]="${hex c.subtext0}"
    theme[meter_bg]="${hex c.surface0}"
    theme[proc_misc]="${hex accentAlt}"

    theme[cpu_box]="${hex c.surface1}"
    theme[mem_box]="${hex c.surface1}"
    theme[net_box]="${hex c.surface1}"
    theme[proc_box]="${hex c.surface1}"
    theme[div_line]="${hex c.surface0}"

    theme[temp_start]="${hex c.green}"
    theme[temp_mid]="${hex c.yellow}"
    theme[temp_end]="${hex c.red}"

    theme[cpu_start]="${hex accentAlt}"
    theme[cpu_mid]="${hex c.yellow}"
    theme[cpu_end]="${hex c.red}"

    theme[free_start]="${hex c.green}"
    theme[free_mid]="${hex c.green}"
    theme[free_end]="${hex c.teal}"

    theme[cached_start]="${hex accent}"
    theme[cached_mid]="${hex accent}"
    theme[cached_end]="${hex c.blue}"

    theme[available_start]="${hex c.yellow}"
    theme[available_mid]="${hex c.yellow}"
    theme[available_end]="${hex c.peach}"

    theme[used_start]="${hex c.peach}"
    theme[used_mid]="${hex c.red}"
    theme[used_end]="${hex c.red}"

    theme[download_start]="${hex c.mauve}"
    theme[download_mid]="${hex c.mauve}"
    theme[download_end]="${hex c.pink}"

    theme[upload_start]="${hex c.green}"
    theme[upload_mid]="${hex c.green}"
    theme[upload_end]="${hex accentAlt}"

    theme[process_start]="${hex accent}"
    theme[process_mid]="${hex c.blue}"
    theme[process_end]="${hex c.mauve}"
  '';

  # ---- neovim -------------------------------------------------------------
  # Alleen de naam: de colorschemes zelf zijn nvim-plugins, niet onze kleuren.
  # config/nvim/lua/plugins/theme.lua leest dit bij het starten.
  "nvim.lua" = ''
    -- ${header}

    return { colorscheme = "${palette.nvimColorscheme}" }
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
