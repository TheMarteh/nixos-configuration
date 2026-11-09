{ lib, pkgs, ... }:

let
  theme = import ../../theme;
  render = import ../../theme/render.nix { inherit (theme) font hex rgba; };

  # Eén .seq per palet, met de ESC]Pn-escapes die het palet van een VT zetten.
  # Bewust in de store en niet uit ~/.config/themes: die map ligt onder
  # /home/steal (0700) en is voor root hier onnodig en voor de greeter
  # onbereikbaar. Alleen de naam van het gekozen thema komt van de gebruiker.
  consoleSeqs = pkgs.linkFarm "console-seqs" (
    lib.mapAttrsToList (themeName: palette: {
      name = "${themeName}.seq";
      path = pkgs.writeText "${themeName}.seq" (render palette)."console.seq";
    }) theme.palettes
  );

  # Draait als root, want het leest ~steal (0700) en schrijft naar de VT's.
  applyConsoleTheme = pkgs.writeShellApplication {
    name = "theme-console";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      seq_dir=${consoleSeqs}
      name=$(cat /home/steal/.local/state/theme 2>/dev/null || true)

      seq="$seq_dir/$name.seq"
      if [ -z "$name" ] || [ ! -f "$seq" ]; then
          seq="$seq_dir/${theme.default.name}.seq"
      fi

      # tuigreet draait als user `greeter` en kan ~steal niet lezen; via /run
      # komt het palet er alsnog. Zie modules/nixos/greetd.nix.
      #
      # Map en bestand op naam van steal, zodat `theme-set` ze bij een wissel
      # kan overschrijven -- anders toont de greeter na uitloggen nog het palet
      # van de laatste boot.
      install -d -m755 -o steal -g users /run/theme
      install -m644 -o steal -g users "$seq" /run/theme/console.seq

      # Het palet is VT-eigen, dus elke console apart. Een VT die niet bestaat
      # of bezet is mag falen -- dan blijft daar het palet uit de initrd staan.
      for tty in /dev/tty[1-6]; do
          cat "$seq" >"$tty" 2>/dev/null || true
      done
    '';
  };
in
{
  console = {
    # tuigreet kan alleen de 16 ANSI-kleuren gebruiken -- de Linux-console kent
    # geen 24-bit kleur -- dus maken we die 16 kleuren zelf Catppuccin Mocha.
    #
    # Dit is het palet van laag B: het geldt vanaf de initrd en blijft de
    # basis waar theme-console.service hieronder op terugvalt.
    colors = theme.ansi;

    # Zet het palet al vanuit de initrd, zodat de console meteen goed is in
    # plaats van pas nadat console-setup gedraaid heeft.
    earlySetup = true;
  };

  # Overschrijft dat basispalet met het thema dat de gebruiker koos. Vóór
  # greetd, zodat het inlogscherm meteen de goede kleuren heeft.
  systemd.services.theme-console = {
    description = "Console-palet van het gekozen thema";
    wantedBy = [ "multi-user.target" ];
    before = [ "greetd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.getExe applyConsoleTheme;
    };
  };
}
