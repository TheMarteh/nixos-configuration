{ ... }:

{
  imports = [
    ./boot.nix
    ./nix.nix
    ./locale.nix
    ./users.nix
    ./hyprland.nix
    ./nvidia.nix
    ./audio.nix
    ./bluetooth.nix
    ./input.nix
    ./docker.nix
    ./virtualisation.nix
    ./fonts.nix
    ./ai.nix
    ./packages.nix
  ];
}
