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
  # waybar, swaync, rofi en hypr staan niet in deze lijst: die worden per
  # bestand gelinkt in hun eigen module, omdat daar ook pakketten en een
  # bestandslijst bij horen. Hun kleuren komen uit ~/.config/current-theme
  # (zie home/theme.nix), niet uit een buurbestand.
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
