{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    obsidian # note-taking app
    # Dolphin buiten KDE: kio-extras voor thumbnails/netwerk, qtsvg voor iconen
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.qtsvg
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    discord
    pkgs-unstable.bolt-launcher # osrs launcher
    yaak # API testing tool
    cura-appimage # 3d print software
  ];
}
