{ ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "steal"
    ];
    auto-optimise-store = true;
    download-buffer-size = 524288000; # 500MB
  };

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  # nh: nettere wrapper rond nixos-rebuild (toont diff) + automatische garbage collection
  programs.nh = {
    enable = true;
    flake = "/home/steal/nixos-configuration";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep 5";
    };
  };
}
