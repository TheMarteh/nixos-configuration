{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-configuration/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
  };
in

{
  # Mapping van dotfiles in ./config naar $HOME/.config.
  # waybar, swaync en hypr staan niet in deze lijst: die hebben een
  # gegenereerd theme-bestand ernaast staan en worden per bestand gelinkt in
  # hun eigen module. Een map als geheel symlinken kan dat niet.
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
