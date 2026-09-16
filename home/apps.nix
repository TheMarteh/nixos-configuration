{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    obsidian # note-taking app
    kdePackages.dolphin # file manager
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    discord
    pkgs-unstable.bolt-launcher # osrs launcher
    yaak # API testing tool
    blueberry # bluetooth management tool
    cura-appimage # 3d print software
  ];
}
