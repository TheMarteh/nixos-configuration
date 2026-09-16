{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    hypr = "hypr";
    waybar = "waybar";
    swaync = "swaync";
  };
in

{
  # Mapping van dotfiles in ./config naar $HOME/.config
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
