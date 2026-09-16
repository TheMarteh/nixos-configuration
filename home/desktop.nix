{ pkgs, pkgs-unstable, ... }:

{
  # swww service voor wallpapers
  services.swww = {
    enable = true;
    package = pkgs-unstable.swww;
  };

  # Wayland/Hyprland tools
  home.packages = with pkgs; [
    wofi
    rofi
    waybar
    brightnessctl
    playerctl
    grim
    slurp
    swaynotificationcenter
    libnotify
    wl-clipboard
    hyprland
  ];
}
