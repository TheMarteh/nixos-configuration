{ ... }:

{
  services.libinput.enable = true;
  services.libinput.mouse = {
    accelProfile = "flat";
  };
}
