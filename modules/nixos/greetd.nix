{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Start Hyprland via UWSM, zodat graphical-session.target actief wordt
  # (nodig voor user-services die daarop wachten).
  #
  # Identiek aan de Exec van het meegeleverde hyprland-uwsm.desktop. Let op: geef
  # de Desktop Entry mee, geen pad naar het binary. Een pad zet UWSM in hardcode
  # mode, waardoor hyprland.desktop wordt overgeslagen en Hyprland niet meer via
  # start-hyprland loopt -- de watchdog die Hyprland na een crash herstart.
  # Zonder dat waarschuwt Hyprland 0.55 bij het inloggen.
  hyprlandSession = "${config.programs.uwsm.package}/bin/uwsm start -e -D Hyprland hyprland.desktop";

  # tuigreet kent alleen de 16 ANSI-kleurnamen; welke kleur daarachter zit
  # bepaalt console.nix uit het palet. cyan = teal, blue = blue, magenta = mauve.
  tuigreetTheme = lib.concatStringsSep ";" [
    "container=black" # base
    "border=cyan" # teal
    "title=cyan"
    "text=white" # text
    "greet=magenta" # mauve
    "time=blue"
    "prompt=gray" # subtext1
    "input=lightcyan"
    "action=gray"
    "button=lightblue" # sky
  ];

  tuigreetArgs = lib.concatStringsSep " " [
    "--cmd '${hyprlandSession}'"
    # Voorgevuld, zodat inloggen neerkomt op Enter en dan je wachtwoord. Verder
    # inkorten kan niet: tuigreet begint altijd in het gebruikersnaamveld.
    "--user steal"
    "--remember"
    "--asterisks"
    "--time"
    "--time-format '%a %d %b  ·  %H:%M'"
    "--greeting 'Welkom terug'"
    "--theme '${tuigreetTheme}'"
    "--window-padding 2"
    "--container-padding 2"
    # F12 opent het power-menu; zonder deze draait tuigreet kale shutdown/reboot
    "--power-shutdown 'systemctl poweroff'"
    "--power-reboot 'systemctl reboot'"
  ];
in
{
  # Login via tuigreet (geen autologin, zodat PAM de keyring kan ontgrendelen)
  services.greetd = {
    enable = true;

    # Zet StandardInput/Output op de tty en houdt systemd-bootmeldingen weg die
    # anders dwars door de TUI heen rommelen.
    useTextGreeter = true;

    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet ${tuigreetArgs}";
      user = "greeter";
    };
  };
}
