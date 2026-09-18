{ config, pkgs, ... }:

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
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Login via tuigreet (geen autologin, zodat PAM de keyring kan ontgrendelen)
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${hyprlandSession}'";
      user = "greeter";
    };
  };

  # Dolphin buiten Plasma: zonder applications.menu is "Open with" leeg.
  # Kopie van plasma-applications.menu uit plasma-workspace (dat pakket zelf is 2.7 GiB).
  environment.etc."xdg/menus/applications.menu".source = ./files/applications.menu;

  # De Hyprland-portal en portals.conf komen al mee met programs.hyprland;
  # GTK-portal voor bestandskiezers en theme detection.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
