# Het systeemmenu op SUPER+SPACE, naar het voorbeeld van Omarchy's omarchy-menu.
#
# Bewust een schil: elk menupunt roept een script aan dat elders al bestaat
# (theme-set, tui-modal, screenshot, hyprshutdown, ...), zodat er geen tweede
# implementatie naast de keybinds ontstaat.
{ pkgs, ... }:

let
  sysmenu = pkgs.writeShellApplication {
    name = "sysmenu";
    runtimeInputs = [ pkgs.findutils ];
    text = ''
      # Eén rofi-aanroep voor elk niveau. Smaller dan de launcher, zodat het
      # duidelijk een menu is en geen zoekvenster.
      rofi_menu() {
          local prompt="$1"
          shift
          printf '%s\n' "$@" \
              | rofi -dmenu -i -p "$prompt" \
                  -theme-str 'window { width: 420px; } listview { lines: 9; }'
      }

      # Losgekoppeld starten, anders houdt het menu de app vast tot hij sluit.
      term() {
          uwsm app -- "''${TERMINAL:-alacritty}" -e "$@" &
      }

      style_menu() {
          case "$(rofi_menu "Stijl" "  Thema" "  Achtergrond" "  Terug")" in
          *Thema) theme-set ;;
          *Achtergrond) wallpaper_menu ;;
          *Terug) main_menu ;;
          esac
      }

      wallpaper_menu() {
          local dir="$HOME/.config/hypr/wallpapers" choice
          choice=$(find -L "$dir" -maxdepth 1 -type f -printf '%f\n' | sort \
              | rofi -dmenu -i -p "Achtergrond") || return 0
          [ -n "$choice" ] || return 0
          awww img "$dir/$choice" --resize crop --fill-color 000000
      }

      capture_menu() {
          case "$(rofi_menu "Vastleggen" \
              "  Gebied" \
              "  Venster" \
              "  Heel scherm" \
              "  Opname starten/stoppen" \
              "  Kleurenpicker" \
              "  Terug")" in
          *Gebied) screenshot region ;;
          *Venster) screenshot window ;;
          *"Heel scherm") screenshot output ;;
          *Opname*) screenrecord ;;
          *Kleurenpicker) hyprpicker -a ;;
          *Terug) main_menu ;;
          esac
      }

      setup_menu() {
          case "$(rofi_menu "Instellen" \
              "  Wifi" \
              "  Bluetooth" \
              "  Geluid" \
              "  Monitoren uit" \
              "  Config bewerken" \
              "  Terug")" in
          *Wifi) tui-modal Wifi nmtui connect ;;
          *Bluetooth) tui-modal Bluetooth bluetui ;;
          *Geluid) tui-modal Wiremix wiremix ;;
          *"Monitoren uit") "$HOME/.config/hypr/scripts/dpms-toggle.sh" ;;
          *"Config bewerken") term nvim "$HOME/nixos-configuration" ;;
          *Terug) main_menu ;;
          esac
      }

      system_menu() {
          case "$(rofi_menu "Systeem" \
              "  Vergrendelen" \
              "  Screensaver" \
              "  Presenteermodus" \
              "  Uitloggen" \
              "  Herstarten" \
              "  Afsluiten" \
              "  Terug")" in
          *Vergrendelen) loginctl lock-session ;;
          *Screensaver) screensaver ;;
          *Presenteermodus) present-mode ;;
          *Uitloggen) hyprshutdown -t 'Uitloggen...' ;;
          *Herstarten) hyprshutdown -t 'Herstarten...' -p 'systemctl reboot' ;;
          *Afsluiten) hyprshutdown -t 'Afsluiten...' -p 'systemctl poweroff' ;;
          *Terug) main_menu ;;
          esac
      }

      update_menu() {
          case "$(rofi_menu "Bijwerken" \
              "  Rebuild (nrs)" \
              "  Flake bijwerken + boot (nrbu)" \
              "  Terug")" in
          # In een terminal, want nh vraagt zelf om sudo en toont een diff.
          *nrs*) term bash -c 'nh os switch; echo; read -rsn1 -p "Toets om te sluiten"' ;;
          *nrbu*) term bash -c 'nh os boot --update; echo; read -rsn1 -p "Toets om te sluiten"' ;;
          *Terug) main_menu ;;
          esac
      }

      main_menu() {
          case "$(rofi_menu "Menu" \
              "  Apps" \
              "  Vensters" \
              "  Klembord" \
              "  Emoji" \
              "  Stijl" \
              "  Vastleggen" \
              "  Instellen" \
              "  Systeem" \
              "  Bijwerken")" in
          *Apps) rofi -show drun -run-command "uwsm app -- {cmd}" ;;
          *Vensters) rofi -show window ;;
          *Klembord) clipboard-history ;;
          *Emoji) rofimoji --selector rofi --clipboarder wl-copy ;;
          *Stijl) style_menu ;;
          *Vastleggen) capture_menu ;;
          *Instellen) setup_menu ;;
          *Systeem) system_menu ;;
          *Bijwerken) update_menu ;;
          esac
      }

      main_menu
    '';
  };
in
{
  home.packages = [ sysmenu ];
}
