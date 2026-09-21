{ config, ... }:

{
  # fzf: Ctrl-R door de geschiedenis, Ctrl-T door bestanden.
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # `z <deel van een pad>` springt naar mappen waar je vaak bent.
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true; # zet ls/ll/la om
    icons = "auto";
    git = true;
  };

  # Geschiedenis in SQLite in plaats van .bash_history: doorzoekbaar en per map.
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    flags = [ "--disable-up-arrow" ]; # pijl omhoog blijft gewoon de vorige regel
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    # Bewust geen `settings`: dan schrijft home-manager hier geen bestand en
    # blijft dit pad de symlink naar het actieve palet. Zie theme/render.nix.
    configPath = "${config.home.homeDirectory}/.config/current-theme/starship.toml";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use NixOS, btw";
      # Dagelijks werk: pakket toevoegen, optie wijzigen, config aanpassen.
      nrs = "nh os switch"; # rebuild + switch, toont eerst een diff (vraagt zelf om sudo)
      nfu = "nix flake update --flake ~/nixos-configuration";

      # Activeer niet live, maar pas na een reboot. Nodig zodra de switch systemd
      # zelf herstart: dat herlaadt de user manager, waardoor UWSM's
      # wayland-session-bindpid wegvalt en die via OnSuccess= de hele
      # Hyprland-sessie afbreekt -- inclusief de terminal waarin de switch draait.
      #
      # Twijfel je? `nixos-rebuild dry-activate --flake ~/nixos-configuration#nixos-steal`
      # zegt "would restart systemd" als je nrb/nrbu nodig hebt.
      #
      # nrbu is bewust boot en geen switch: een flake-update trekt vrijwel altijd
      # een nieuwe systemd mee.
      nrb = "nh os boot && echo 'Klaar - herstart om de nieuwe generatie te gebruiken.'";
      nrbu = "nh os boot --update && echo 'Klaar - herstart om de nieuwe generatie te gebruiken.'";
      # Via hyprshutdown, zodat apps eerst netjes afsluiten (`sudo reboot` omzeilt dit)
      reboot = "hyprshutdown -t 'Herstarten...' -p 'systemctl reboot'";
      poweroff = "hyprshutdown -t 'Afsluiten...' -p 'systemctl poweroff'";
    };
  };
}
