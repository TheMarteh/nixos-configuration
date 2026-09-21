{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    hypr = "hypr";
    swaync = "swaync";
  };
in

{
  # Mapping van dotfiles in ./config naar $HOME/.config.
  # waybar staat niet in deze lijst: die heeft een gegenereerde theme.css
  # ernaast en wordt per bestand gelinkt in waybar.nix.
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
