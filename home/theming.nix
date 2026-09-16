{ pkgs, ... }:

{
  # Dark mode voorkeur voor GTK4/libadwaita apps en portals.
  # (Geen GTK_THEME env var: die breekt de styling van libadwaita apps.)
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # GTK Theme (voor Firefox, GNOME apps, etc.)
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt Theme (voor Dolphin, Rider, KDE apps)
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = [
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
      ];
    };
  };
}
