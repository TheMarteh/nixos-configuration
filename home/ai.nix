{ pkgs-unstable, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-cuda;
  };

  home.packages = [ pkgs-unstable.claude-code ];
}
