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

    # Geen gtk-theme-name voor GTK4: libadwaita negeert die en volgt color-scheme
    # hierboven. Dit is de 26.05-default van home-manager; expliciet gezet omdat
    # home.stateVersion nog op 25.05 staat en anders het oude gedrag geldt.
    gtk4.theme = null;

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
