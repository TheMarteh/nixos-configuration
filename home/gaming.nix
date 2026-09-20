{ pkgs, ... }:

let
  # Lutris uit nixpkgs draait in een FHS-sandbox, waardoor de Wine-runners die
  # Lutris zelf downloadt (wine-ge, proton-ge) gewoon werken op NixOS. Maar de
  # installers roepen winetricks, cabextract en gamemoderun aan als gewone
  # commando's -- die moeten dus *binnen* die sandbox staan, niet ernaast in
  # home.packages. Vandaar deze override.
  lutris = pkgs.lutris.override {
    steamSupport = false; # geen Steam op dit systeem

    extraPkgs =
      p: with p; [
        winetricks
        wineWowPackages.stagingFull # 32+64-bit; de Rockstar Launcher heeft beide nodig
        gamemode
        gamescope
        mangohud
        python3
        cabextract
        p7zip
      ];
  };
in
{
  home.packages = [
    lutris
    pkgs.protontricks # winetricks tegen een bestaande Proton-prefix
    pkgs.mangohud # framerate-overlay
    pkgs.vulkan-tools # vulkaninfo, om te zien of de GPU wordt gevonden
  ];
}
