{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use NixOS, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-configuration#nixos-steal";
      nfu = "nix flake update --flake ~/nixos-configuration";
    };
  };
}
