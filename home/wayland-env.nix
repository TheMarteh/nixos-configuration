{ ... }:

{
  home.sessionVariables = {
    # Java/AWT apps under XWayland (e.g. RuneLite via Bolt)
    _JAVA_AWT_WM_NONREPARENTING = "1"; # fixes blank/grey windows & resize glitches on tiling WMs

    # Electron apps op Wayland
    ELECTRON_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    QT_QPA_PLATFORM = "xcb";
  };
}
