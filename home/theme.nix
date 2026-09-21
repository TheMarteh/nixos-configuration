# Bouwt élk palet uit theme/palettes/ naar ~/.config/themes/<naam>/ en levert
# `theme-set` om daartussen te wisselen zonder rebuild.
#
# De catalogus ~/.config/themes/ is volledig home-manager-bezit en dus een
# read-only symlink naar de store. Het aanwijsbord is een losse symlink
# ~/.config/current-theme die theme-set verzet -- die staat bewust búíten de
# catalogus, anders zou hij in de read-only store-map moeten worden aangemaakt.
#
# Zie theme/default.nix voor wat wél en niet runtime te wisselen is.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  theme = import ../theme;
  render = import ../theme/render.nix { inherit (theme) font hex rgba; };

  # { "themes/nord/waybar.css" = { text = "..."; }; ... } voor alle palettes.
  themeFiles = lib.concatMapAttrs (
    themeName: palette:
    lib.mapAttrs' (
      fileName: text: lib.nameValuePair "themes/${themeName}/${fileName}" { inherit text; }
    ) (render palette)
  ) theme.palettes;

  theme-set = pkgs.writeShellApplication {
    name = "theme-set";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      default_theme=${theme.default.name}

      themes_dir="$HOME/.config/themes"
      current="$HOME/.config/current-theme"
      state_file="$HOME/.local/state/theme"
      quiet=0

      usage() {
          cat <<'USAGE'
      theme-set [THEMA]

      Wisselt het actieve thema zonder rebuild. Zonder argument opent een rofi-menu.

        -l, --list   toon de beschikbare thema's
            --sync   pas het opgeslagen thema opnieuw toe en val zo nodig terug
                     op het standaardthema (gebruikt door de home-manager-activatie)
        -h, --help   deze tekst
      USAGE
      }

      # -L, want ~/.config/themes is zelf een symlink naar de store en de
      # palet-mappen erin kunnen dat ook zijn.
      theme_names() {
          find -L "$themes_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
      }

      # In een subshell, zodat de variabelen uit meta.sh niet blijven hangen.
      label_of() (
          # shellcheck source=/dev/null
          . "$themes_dir/$1/meta.sh" 2>/dev/null || true
          printf '%s\n' "''${theme_label:-$1}"
      )

      pick_theme() {
          local choice name
          choice=$(theme_names | while read -r name; do label_of "$name"; done \
              | rofi -dmenu -i -p "Thema" -theme-str 'window { width: 420px; }') || return 1
          [ -n "$choice" ] || return 1

          # Procesvervanging in plaats van een pipe: een `while` achter een pipe
          # draait in een subshell, en dan bepaalt de laatste iteratie de
          # exitcode in plaats van de gevonden match.
          while read -r name; do
              if [ "$(label_of "$name")" = "$choice" ]; then
                  printf '%s\n' "$name"
                  return 0
              fi
          done < <(theme_names)
          return 1
      }

      # Elke stap mag falen: theme-set draait ook vanuit de home-manager-activatie,
      # en dan is er (nog) geen Hyprland-sessie om te herladen.
      reload() {
          hyprctl reload >/dev/null 2>&1 || true
          # waybar herleest config én stylesheet op SIGUSR2. Matchen op de
          # commandline en niet op de procesnaam: de NixOS-wrapper noemt het
          # proces .waybar-wrapped, dus `pkill -x waybar` raakt niets.
          pkill -USR2 -f '/bin/waybar$' >/dev/null 2>&1 || true
          swaync-client --reload-css >/dev/null 2>&1 || true

          if [ -n "''${theme_wallpaper:-}" ]; then
              awww img "$HOME/.config/hypr/wallpapers/$theme_wallpaper" \
                  --resize crop --fill-color 000000 >/dev/null 2>&1 || true
          fi

          if [ "$quiet" -eq 0 ]; then
              notify-send -a theme-set "Thema gewisseld" "''${theme_label:-$1}" \
                  >/dev/null 2>&1 || true
          fi
      }

      apply() {
          local name="$1" dir
          dir="$themes_dir/$name"

          if [ ! -d "$dir" ]; then
              printf 'theme-set: onbekend thema %s\n' "$name" >&2
              printf 'beschikbaar: %s\n' "$(theme_names | tr '\n' ' ')" >&2
              return 1
          fi

          # shellcheck source=/dev/null
          . "$dir/meta.sh"

          # Eerst ernaast, dan atomair op zijn plek: een half verzette symlink
          # zou waybar en rofi zonder kleuren achterlaten.
          ln -sfn "$dir" "$current.new"
          mv -Tf "$current.new" "$current"

          mkdir -p "$(dirname "$state_file")"
          printf '%s\n' "$name" >"$state_file"

          reload "$name"
      }

      case "''${1:-}" in
      -h | --help)
          usage
          exit 0
          ;;
      -l | --list)
          theme_names
          exit 0
          ;;
      --sync)
          quiet=1
          name=$(cat "$state_file" 2>/dev/null || true)
          if [ -z "$name" ] || [ ! -d "$themes_dir/$name" ]; then
              name="$default_theme"
          fi
          apply "$name"
          ;;
      "")
          name=$(pick_theme) || exit 0
          [ -n "$name" ] || exit 0
          apply "$name"
          ;;
      -*)
          usage >&2
          exit 1
          ;;
      *)
          apply "$1"
          ;;
      esac
    '';
  };
in
{
  xdg.configFile = themeFiles;

  home.packages = [ theme-set ];

  # Zorgt dat ~/.config/current-theme bestaat op een verse machine, en past na
  # elke `nrs` het opgeslagen thema opnieuw toe -- zo komt een wijziging in
  # theme/palettes/ of theme/render.nix ook echt door.
  home.activation.seedTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe theme-set} --sync || true
  '';
}
