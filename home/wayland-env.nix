{ ... }:

{
  home.sessionVariables = {
    # Java/AWT apps under XWayland (e.g. RuneLite via Bolt)
    _JAVA_AWT_WM_NONREPARENTING = "1"; # fixes blank/grey windows & resize glitches on tiling WMs

    # Electron/Chromium apps native op Wayland
    NIXOS_OZONE_WL = "1";
  };
}
