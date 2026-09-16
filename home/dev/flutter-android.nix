{ pkgs, ... }:

{
  # Build-dependencies voor Linux desktop builds staan in templates/flutter.
  home.packages = with pkgs; [
    flutter
    android-studio # IDE + emulator (via Device Manager)
    android-tools # adb en fastboot
  ];
}
