{ ... }:

{
  # GameMode: zet tijdens het spelen de CPU-governor op performance en geeft het
  # spel I/O- en scheduler-prioriteit. Lutris start games met `gamemoderun` zodra
  # de daemon draait ("Enable Feral GameMode" in de System options van een game).
  programs.gamemode.enable = true;

  # Gamescope als micro-compositor. Onder Hyprland + NVIDIA lost dat de
  # fullscreen-, alt-tab- en cursor-grabproblemen van Wine-games op.
  programs.gamescope = {
    enable = true;
    capSysNice = true; # realtime-prioriteit zonder root
  };
}
