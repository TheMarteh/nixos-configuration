{ ... }:

{
  imports = [
    ./dotfiles.nix
    ./theming.nix
    ./wayland-env.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./desktop.nix
    ./secrets.nix
    ./browsers.nix
    ./apps.nix
    ./ai.nix
    ./dev/direnv.nix
    ./dev/neovim.nix
    ./dev/dotnet.nix
    ./dev/flutter-android.nix
    ./dev/vscode.nix
    ./dev/docker.nix
    ./dev/editors.nix
  ];

  home.username = "steal";
  home.homeDirectory = "/home/steal";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
