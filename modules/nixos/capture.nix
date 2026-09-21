{ ... }:

{
  # Installeert gpu-screen-recorder met een setcap-wrapper voor gsr-kms-server,
  # zodat opnemen zonder portal-dialoog kan. Systeemniveau, want die capability
  # kan home-manager niet zetten. Zie home/capture.nix voor waarom het niet
  # wl-screenrec of wf-recorder is geworden.
  programs.gpu-screen-recorder.enable = true;
}
