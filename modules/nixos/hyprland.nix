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
