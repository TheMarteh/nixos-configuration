{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # voorkomt dat /boot volloopt
  boot.loader.efi.canTouchEfiVariables = true;
}
