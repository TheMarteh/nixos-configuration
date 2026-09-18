{ ... }:

let
  # Hyprland start alles via `uwsm app --`, dus als systemd-user-unit. Die units
  # erven hun omgeving van de user manager, niet van Hyprland -- `hl.env(...)` in
  # hyprland.lua bereikt ze dus niet. Vandaar dat deze variabelen hier staan.
  #
  # Ze worden op twee plekken gezet:
  #   systemd.user.sessionVariables -> ~/.config/environment.d, gelezen door de
  #     systemd user manager. Dekt Hyprland zelf en elke `uwsm app`.
  #   home.sessionVariables -> hm-session-vars.sh, gesourcet door de login shell.
  #     Dekt apps die je vanuit een terminal start.
  sessionVariables = {
    # Java/AWT apps onder XWayland (bijv. RuneLite via Bolt): voorkomt blanco/
    # grijze vensters en resize-glitches op tiling WM's.
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # Electron/Chromium apps native op Wayland
    NIXOS_OZONE_WL = "1";

    # Cursorgrootte voor clients
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";

    GDK_SCALE = "1";

    # NVIDIA (https://wiki.hypr.land/Configuring/Advanced-and-Cool/Nvidia/)
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
in

{
  home.sessionVariables = sessionVariables;
  systemd.user.sessionVariables = sessionVariables;
}
