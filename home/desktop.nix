{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  swayosdConfig = "${config.home.homeDirectory}/nixos-configuration/config/swayosd";
  link = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # Polkit-authenticatieagent: zonder deze faalt elke rechtenprompt stil
  # (blueman, 1Password systeemauthenticatie, virt-manager, ...).
  # Hangt zelf aan graphical-session.target, dus geen exec-once nodig.
  services.hyprpolkitagent.enable = true;

  # On-screen display voor volume, helderheid en capslock. Zonder deze gaven de
  # multimediatoetsen geen enkele visuele terugkoppeling.
  #
  # Geen stylePath: dat zou een store-pad zijn en dus een vast palet. Zonder die
  # optie zoekt swayosd zelf ~/.config/swayosd/style.css, en dat bestand
  # importeert uit ~/.config/current-theme.
  services.swayosd.enable = true;
  xdg.configFile."swayosd/style.css".source = link "${swayosdConfig}/style.css";

  # Wayland/Hyprland tools
  home.packages = with pkgs; [
    # Wallpaper daemon (opvolger van swww), gestart via hl.on("hyprland.start") in hyprland.lua.
    # Niet via services.swww: die module start hardcoded `swww-daemon`.
    pkgs-unstable.awww
    # Sluit eerst alle apps netjes af (zodat o.a. Firefox zijn sessie opslaat)
    # en stopt daarna pas Hyprland. Staat nog niet in 25.11.
    pkgs-unstable.hyprshutdown
    # nm-applet (tray) + nm-connection-editor voor de waybar-klik
    networkmanagerapplet
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
