# De waybar-iconen openen een zwevende terminal met een TUI erin, in plaats van
# een losse GUI-applicatie. Een tweede klik sluit hem weer.
#
# De window rule die zo'n venster laat zweven en centreert staat in
# config/hypr/windowrules.lua en matcht op de class die `tui-modal` meegeeft.
{ pkgs, ... }:

let
  tui-modal = pkgs.writeShellApplication {
    name = "tui-modal";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      if [ "$#" -lt 2 ]; then
          echo "gebruik: tui-modal <class> <commando> [argumenten...]" >&2
          exit 1
      fi

      class="$1"
      shift

      # Al open? Dan is deze klik bedoeld om hem weg te halen.
      if hyprctl clients -j | jq -e --arg c "$class" 'any(.[]; .class == $c)' >/dev/null; then
          # Sinds 0.55 neemt `hyprctl dispatch` Lua, geen `class:^...$`-selector
          # meer -- die oude vorm geeft een parsefout en doet niets.
          hyprctl dispatch "hl.dsp.window.close(hl.get_windows({ class = \"$class\" })[1])" >/dev/null
      else
          # Via uwsm, net als al het andere dat Hyprland start: dan wordt het een
          # systemd-user-unit met de juiste omgeving. In de achtergrond, zodat een
          # klik op waybar of een menukeuze niet blijft hangen tot het venster
          # sluit; de unit is van de user manager en overleeft deze shell.
          uwsm app -- alacritty --class "$class" -e "$@" &
      fi
    '';
  };
in
{
  home.packages = [
    tui-modal
    pkgs.impala # wifi
    pkgs.bluetui # bluetooth
    pkgs.wiremix # pipewire-volume en -routing
  ];
}
