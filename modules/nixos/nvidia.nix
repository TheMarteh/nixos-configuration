{ ... }:

{
  # nvidia-vaapi-driver (video decoding op de GPU) wordt automatisch toegevoegd
  hardware.graphics.enable = true;

  hardware.nvidia = {
    open = true;
    # Bewaart VRAM bij suspend, voorkomt corruptie na resume
    powerManagement.enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
