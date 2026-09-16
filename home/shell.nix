{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use NixOS, btw";
      nrs = "nh os switch"; # rebuild + switch, toont eerst een diff (vraagt zelf om sudo)
      nfu = "nix flake update --flake ~/nixos-configuration";
      nrsu = "nh os switch --update"; # nfu + nrs in één keer
    };
  };
}
