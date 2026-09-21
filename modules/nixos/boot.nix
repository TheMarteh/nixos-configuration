{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # voorkomt dat /boot volloopt
  boot.loader.efi.canTouchEfiVariables = true;

  # fbcon stelt het overnemen van de console normaal uit tot er iets naar te
  # schrijven valt. Tot dat moment is de console een dummy van 80x25, en start
  # greetd daar seconden eerder dan de overname: tuigreet tekent zijn eerste
  # frames linksboven op 80x25 en verspringt zodra fbcon naar 160x45 schakelt.
  # nodefer laat fbcon meteen overnemen, op de echte grootte.
  boot.kernelParams = [ "fbcon=nodefer" ];
}
