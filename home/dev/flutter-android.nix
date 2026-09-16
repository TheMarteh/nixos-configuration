{ pkgs, ... }:

let
  androidEmu = pkgs.androidenv.emulateApp {
    name = "emulate-MyAndroidApp";
    platformVersion = "36";
    abiVersion = "x86_64";
    systemImageType = "google_apis_playstore";
  };
in

{
  home.sessionVariables = {
    ANDROID_EMULATOR_USE_SYSTEM_LIBS = "1";

    # Flutter Linux build dependencies (pkg-config paths)
    PKG_CONFIG_PATH = "${pkgs.libsecret.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
  };

  home.packages = with pkgs; [
    flutter
    cmake
    ninja
    pkg-config
    libsecret

    android-studio # Android development IDE
    android-tools # ADB en Fastboot tools
    android-studio-tools # Android emulator en cli
    androidEmu # Android emulator instance
  ];
}
