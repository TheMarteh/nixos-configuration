# Schermafbeeldingen, schermopname, kleurenpicker, klembordgeschiedenis en een
# emoji-kiezer. Alles komt op het klembord terecht, niet alleen op schijf --
# dat was met kale grim/slurp niet zo.
{
  config,
  pkgs,
  ...
}:

let
  shotDir = "${config.home.homeDirectory}/Pictures/Screenshots";
  castDir = "${config.home.homeDirectory}/Videos/Screencasts";

  # hyprshot geeft met -r de ruwe PNG op stdout; satty pakt die op, laat je
  # annoteren en zet het resultaat op het klembord én in een bestand.
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [
      pkgs.hyprshot
      pkgs.satty
      pkgs.wl-clipboard
      pkgs.coreutils
    ];
    text = ''
      mode="''${1:-region}"
      case "$mode" in
      region | window | output) ;;
      *)
          echo "gebruik: screenshot [region|window|output]" >&2
          exit 1
          ;;
      esac

      mkdir -p "${shotDir}"

      # -s: hyprshot stuurt zelf geen notificatie; die komt van satty na het opslaan.
      hyprshot -m "$mode" -r -s \
          | satty --filename - \
              --output-filename "${shotDir}/$(date +%Y%m%d-%H%M%S).png" \
              --early-exit \
              --copy-command wl-copy \
              --initial-tool brush
    '';
  };

  # LET OP: schermopname én schermafbeeldingen werken op deze machine op dit
  # moment niet, en dat lag al vóór deze module. `grim` blijft hangen zonder
  # foutmelding, wl-screenrec faalt met "failed to select a viable capture
  # format" op NVIDIA's block-linear dmabuf-modifiers, en wf-recorder selecteert
  # wel een regio maar krijgt nooit frames. Alle drie gaan via
  # wlr-screencopy; Hyprland biedt dat protocol nog aan (zwlr_screencopy_manager_v1
  # v3) en ecosystem:enforce_permissions staat uit, dus de oorzaak zit dieper --
  # vermoedelijk in de NVIDIA-dmabuf-pad.
  #
  # gpu-screen-recorder staat hier omdat het níét via wlr-screencopy gaat maar
  # via KMS en NVENC, en juist voor NVIDIA is gemaakt. Ongetest: de
  # setcap-wrapper uit modules/nixos/capture.nix bestaat pas na een rebuild.
  screenrecord = pkgs.writeShellApplication {
    name = "screenrecord";
    runtimeInputs = [
      pkgs.jq
      pkgs.coreutils
    ];
    text = ''
      pidfile="''${XDG_RUNTIME_DIR:-/tmp}/screenrecord.pid"

      running() {
          [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null
      }

      # Voor de waybar-indicator: een rood bolletje tijdens de opname, en
      # anders niets -- waybar verbergt een module met lege uitvoer.
      if [ "''${1:-}" = "--status" ]; then
          if running; then
              printf '\n'
          fi
          exit 0
      fi

      if running; then
          # SIGINT, niet SIGTERM: alleen dan schrijft de recorder de index van
          # het mp4-bestand nog weg en is de opname afspeelbaar.
          kill -INT "$(cat "$pidfile")"
          rm -f "$pidfile"
          notify-send -a screenrecord "Opname gestopt" "Bewaard in ${castDir}" || true
          exit 0
      fi

      mkdir -p "${castDir}"
      monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

      gpu-screen-recorder -w "$monitor" -f 60 -k h264 \
          -o "${castDir}/$(date +%Y%m%d-%H%M%S).mp4" >/dev/null 2>&1 &
      echo $! >"$pidfile"

      notify-send -a screenrecord "Opname gestart" "$monitor" || true
    '';
  };
  # Zelfde aanroep voor de keybind en voor het systeemmenu.
  clipboard-history = pkgs.writeShellApplication {
    name = "clipboard-history";
    runtimeInputs = [
      pkgs.cliphist
      pkgs.wl-clipboard
    ];
    text = ''
      cliphist list \
          | rofi -dmenu -i -p "Klembord" -theme-str 'window { width: 900px; }' \
          | cliphist decode \
          | wl-copy
    '';
  };
in
{
  home.packages = [
    clipboard-history
    screenshot
    screenrecord
    pkgs.hyprpicker # kleurenpicker
    pkgs.rofimoji # emoji-kiezer, gebruikt rofi als selector
  ];

  # Klembordgeschiedenis als user-service; uitlezen doet de keybind met rofi.
  services.cliphist.enable = true;

  # grim faalt op een verse machine als deze mappen niet bestaan.
  home.file."Pictures/Screenshots/.keep".text = "";
  home.file."Videos/Screencasts/.keep".text = "";
}
