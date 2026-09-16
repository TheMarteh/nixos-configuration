{ ... }:

{
  # Realtime scheduling voor PipeWire (voorkomt crackles)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
