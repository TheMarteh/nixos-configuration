{ pkgs, ... }:

{
  # Rootful Docker; toegang zonder sudo via de docker-groep (zie users.nix).
  # GPU in containers: nvidia-container-toolkit (nvidia.nix) zet CDI automatisch aan.
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };
}
