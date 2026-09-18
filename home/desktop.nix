{ pkgs, pkgs-unstable, ... }:

{
  # Polkit-authenticatieagent: zonder deze faalt elke rechtenprompt stil
  # (blueman, 1Password systeemauthenticatie, virt-manager, ...).
  # Hangt zelf aan graphical-session.target, dus geen exec-once nodig.
  services.hyprpolkitagent.enable = true;

  # Wayland/Hyprland tools
  home.packages = with pkgs; [
    # Wallpaper daemon (opvolger van swww), gestart via exec-once in hyprland.conf.
    # Niet via services.swww: die module start hardcoded `swww-daemon`.
    pkgs-unstable.awww
    # Sluit eerst alle apps netjes af (zodat o.a. Firefox zijn sessie opslaat)
    # en stopt daarna pas Hyprland. Staat nog niet in 25.11.
    pkgs-unstable.hyprshutdown
    # nm-applet (tray) + nm-connection-editor voor de waybar-klik
    networkmanagerapplet
    rofi
    waybar
    brightnessctl
    playerctl
    grim
    slurp
    swaynotificationcenter
    libnotify
    wl-clipboard
  ];
}
