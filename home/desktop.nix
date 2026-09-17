{ pkgs, pkgs-unstable, ... }:

{
  # Wayland/Hyprland tools
  home.packages = with pkgs; [
    # Wallpaper daemon (opvolger van swww), gestart via exec-once in hyprland.conf.
    # Niet via services.swww: die module start hardcoded `swww-daemon`.
    pkgs-unstable.awww
    # Sluit eerst alle apps netjes af (zodat o.a. Firefox zijn sessie opslaat)
    # en stopt daarna pas Hyprland. Staat nog niet in 25.11.
    pkgs-unstable.hyprshutdown
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
