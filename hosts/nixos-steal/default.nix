{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixos-steal";

  # Eerste NixOS-versie op deze machine. NIET aanpassen bij upgrades.
  system.stateVersion = "25.05";
}
