{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
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
