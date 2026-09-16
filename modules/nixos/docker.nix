{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    rootless = {
      enable = true;
      package = pkgs.docker_29;
      setSocketVariable = true;
    };
  };
}
