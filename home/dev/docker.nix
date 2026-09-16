{ pkgs, ... }:

{
  programs.docker-cli.enable = true;
  programs.lazydocker.enable = true;

  home.packages = [ pkgs.lazydocker ];
}
