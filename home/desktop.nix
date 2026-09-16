{ pkgs, pkgs-unstable, ... }:

{
  # Wayland/Hyprland tools
  home.packages = with pkgs; [
    # Wallpaper daemon (opvolger van swww), gestart via exec-once in hyprland.conf.
    # Niet via services.swww: die module start hardcoded `swww-daemon`.
    pkgs-unstable.awww
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
