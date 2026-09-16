{ pkgs, pkgs-unstable, ... }:

let
  # RuneLite (via Bolt) is een Java-app onder XWayland. Door `xwayland:force_zero_scaling`
  # tekent die op 1x en is hij te klein op een geschaald scherm. Laat Java zelf schalen,
  # gelijk aan de monitorschaal in config/hypr/monitors.conf. Alleen voor Bolt, zodat
  # andere Java-apps (Rider, Android Studio) er geen last van hebben.
  runeliteScale = "1.333333";

  bolt-launcher = pkgs.symlinkJoin {
    name = "bolt-launcher";
    paths = [ pkgs-unstable.bolt-launcher ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bolt-launcher \
        --set JDK_JAVA_OPTIONS "-Dsun.java2d.uiScale=${runeliteScale}"
    '';
  };
in
{
  home.packages = with pkgs; [
    obsidian # note-taking app
    # Dolphin buiten KDE: kio-extras voor thumbnails/netwerk, qtsvg voor iconen
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.qtsvg
    pkgs-unstable.whatsapp-electron # WhatsApp desktop client
    discord
    bolt-launcher # osrs launcher
    yaak # API testing tool
    cura-appimage # 3d print software
  ];
}
