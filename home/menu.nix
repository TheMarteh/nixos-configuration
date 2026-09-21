# Het systeemmenu op SUPER+SPACE, naar het voorbeeld van Omarchy's omarchy-menu.
#
# Bewust een schil: elk menupunt roept een script aan dat elders al bestaat
# (theme-set, tui-modal, screenshot, hyprshutdown, ...), zodat er geen tweede
# implementatie naast de keybinds ontstaat.
{ pkgs, ... }:

let
  # Wifi-kiezer in rofi in plaats van een TUI in een venster. Niet impala, wat
  # Omarchy gebruikt: dat praat uitsluitend met iwd (net.connman.iwd.*) en deze
  # machine draait NetworkManager. En niet nmtui, want dan zou er ineens een
  # newt-dialoog tussen de rest staan. Zo volgt het menu gewoon het palet.
  wifi-menu = pkgs.writeShellApplication {
    name = "wifi-menu";
    runtimeInputs = [
      pkgs.networkmanager
      pkgs.gawk
      pkgs.gnugrep
      pkgs.coreutils
    ];
    text = ''
      icons=(󰤯 󰤟 󰤢 󰤥 󰤨)

      notify() {
          notify-send -a wifi-menu "$@" >/dev/null 2>&1 || true
      }

      pick() {
          rofi -dmenu -i -p "Wifi" -format i \
              -theme-str 'window { width: 520px; } listview { lines: 8; }' "$@"
      }

      if [ "$(nmcli radio wifi)" != "enabled" ]; then
          if printf '%s\n' "󰤮  Wifi inschakelen" | pick >/dev/null; then
              nmcli radio wifi on
              notify "Wifi" "Ingeschakeld"
          fi
          exit 0
      fi

      # Sterkste AP per SSID. nmcli -t escapet een dubbele punt in de SSID als
      # \:, dus die zetten we met de SSID achteraan weer in elkaar.
      mapfile -t nets < <(
          nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan auto \
              | awk -F: '
                  {
                      use = $1; sig = $2 + 0; sec = $3
                      ssid = $4
                      for (i = 5; i <= NF; i++) ssid = ssid ":" $i
                      gsub(/\\/, "", ssid)
                      if (ssid == "") next                      # verborgen netwerk
                      if (!(ssid in best) || sig > best[ssid]) {
                          best[ssid] = sig; inuse[ssid] = use; secu[ssid] = sec
                      }
                  }
                  # Scheiden met US (\037) en niet met een tab: read() ziet een tab
                  # als witruimte en klapt er twee op rij samen, waardoor een leeg
                  # security-veld (open netwerk) alle velden zou laten opschuiven.
                  END { for (s in best) printf "%d\037%s\037%s\037%s\n", best[s], inuse[s], secu[s], s }
              ' \
              | sort -rn
      )

      entries=()
      for net in "''${nets[@]}"; do
          IFS=$'\037' read -r sig use sec ssid <<<"$net"

          if   [ "$sig" -ge 80 ]; then i=4
          elif [ "$sig" -ge 60 ]; then i=3
          elif [ "$sig" -ge 40 ]; then i=2
          elif [ "$sig" -ge 20 ]; then i=1
          else                         i=0
          fi

          suffix=""
          [ -n "$sec" ] && suffix="  "
          [ "$use" = "*" ] && suffix="$suffix  "

          entries+=("''${icons[$i]}  $ssid$suffix")
      done

      entries+=("󰤮  Wifi uitschakelen")

      sel=$(printf '%s\n' "''${entries[@]}" | pick) || exit 0
      [ -n "$sel" ] || exit 0

      # Laatste regel is de schakelaar, de rest zijn netwerken.
      if [ "$sel" -ge "''${#nets[@]}" ]; then
          nmcli radio wifi off
          notify "Wifi" "Uitgeschakeld"
          exit 0
      fi

      IFS=$'\037' read -r _ use sec ssid <<<"''${nets[$sel]}"

      if [ "$use" = "*" ]; then
          notify "Wifi" "Al verbonden met $ssid"
          exit 0
      fi

      # Bekend profiel? Dan is het wachtwoord al opgeslagen.
      if nmcli -t -g NAME connection show | grep -qxF "$ssid"; then
          if out=$(nmcli connection up id "$ssid" 2>&1); then
              notify "Wifi" "Verbonden met $ssid"
          else
              notify -u critical "Wifi" "$out"
          fi
          exit 0
      fi

      if [ -n "$sec" ]; then
          pw=$(rofi -dmenu -password -p "Wachtwoord voor $ssid" \
              -theme-str 'window { width: 520px; } listview { enabled: false; }') || exit 0
          [ -n "$pw" ] || exit 0
          out=$(nmcli device wifi connect "$ssid" password "$pw" 2>&1) && ok=1 || ok=0
      else
          out=$(nmcli device wifi connect "$ssid" 2>&1) && ok=1 || ok=0
      fi

      if [ "$ok" = 1 ]; then
          notify "Wifi" "Verbonden met $ssid"
      else
          notify -u critical "Wifi" "$out"
      fi
    '';
  };

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
          *Wifi) wifi-menu ;;
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
  home.packages = [
    sysmenu
    wifi-menu
  ];
}
