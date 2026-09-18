{ ... }:

{
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
