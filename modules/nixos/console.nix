{ ... }:

let
  theme = import ../../theme;
in
{
  console = {
    # tuigreet kan alleen de 16 ANSI-kleuren gebruiken -- de Linux-console kent
    # geen 24-bit kleur -- dus maken we die 16 kleuren zelf Catppuccin Mocha.
    colors = theme.ansi;

    # Zet het palet al vanuit de initrd, zodat de console meteen goed is in
    # plaats van pas nadat console-setup gedraaid heeft.
    earlySetup = true;
  };
}
