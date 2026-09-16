{ ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "steal" ];
    auto-optimise-store = true;
    download-buffer-size = 524288000; # 500MB
  };

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };
}
