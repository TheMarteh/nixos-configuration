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

    # CUDA-pakketten (ollama-cuda, btop-cuda) staan niet op cache.nixos.org
    extra-substituters = [ "https://cache.nixos-cuda.org" ];
    extra-trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
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
