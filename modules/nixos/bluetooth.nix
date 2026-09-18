{ ... }:

{
  # Bluetooth manager + tray applet (gestart in hyprland.lua)
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
}
