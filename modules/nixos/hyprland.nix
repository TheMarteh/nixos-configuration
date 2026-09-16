{ config, pkgs, ... }:

let
  # Start Hyprland via UWSM, zodat graphical-session.target actief wordt
  # (nodig voor user-services die daarop wachten).
  hyprlandSession = "${config.programs.uwsm.package}/bin/uwsm start -F -- /run/current-system/sw/bin/Hyprland";
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

  # De Hyprland-portal en portals.conf komen al mee met programs.hyprland;
  # GTK-portal voor bestandskiezers en theme detection.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
