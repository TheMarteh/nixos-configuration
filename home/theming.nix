{ pkgs, ... }:

let
  theme = import ../theme;

  # GTK en Qt volgen het palet niet in kleur -- daarvoor zou een complete
  # stylesheet gegenereerd moeten worden -- maar wel in licht/donker. Alle
  # palettes in theme/palettes/ zijn nu donker; dit is de haak voor als daar een
  # licht palet bij komt. Let op: dit is laag B, dus pas actief na een rebuild.
  dark = theme.variant != "light";
in
{
  # Voorkeur voor GTK4/libadwaita apps en portals.
  # (Geen GTK_THEME env var: die breekt de styling van libadwaita apps.)
  dconf.settings."org/gnome/desktop/interface".color-scheme =
    if dark then "prefer-dark" else "prefer-light";

  # GTK Theme (voor Firefox, GNOME apps, etc.)
  gtk = {
    enable = true;

    theme = {
      name = if dark then "Adwaita-dark" else "Adwaita";
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
      gtk-application-prefer-dark-theme = if dark then 1 else 0;
    };

    # Geen gtk-theme-name voor GTK4: libadwaita negeert die en volgt color-scheme
    # hierboven. Dit is de 26.05-default van home-manager; expliciet gezet omdat
    # home.stateVersion nog op 25.05 staat en anders het oude gedrag geldt.
    gtk4.theme = null;

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = if dark then 1 else 0;
    };
  };

  # Qt Theme (voor Dolphin, Rider, KDE apps)
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = if dark then "adwaita-dark" else "adwaita";
      package = [
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
      ];
    };
  };
}
