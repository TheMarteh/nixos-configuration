# nixos-configuration

A collection of config files for my NixOS installation.

Largely based off of [tony banters](https://github.com/tonybanters/) videos.

## Structuur

```
flake.nix               inputs en de nixosConfiguration
hosts/nixos-steal/      machine-specifiek: hardware, hostname, stateVersion
modules/nixos/          systeemmodules (boot, nvidia, hyprland, docker, ...)
home/                   home-manager modules (theming, shell, apps, ...)
home/dev/               development tooling per stack (dotnet, flutter, ...)
config/                 dotfiles, gesymlinkt naar ~/.config (zie home/dotfiles.nix)
```

Iets toevoegen: maak een nieuw `.nix`-bestand in de juiste map, voeg het toe aan
de `imports` in `default.nix` van die map en **`git add` het bestand**, anders
ziet de flake het niet.

## Commando's

| Alias | Wat                                                        |
| ----- | ---------------------------------------------------------- |
| `nrs` | rebuild + switch (via `nh`, toont eerst een pakketten-diff) |
| `nfu` | `flake.lock` updaten                                       |
| `nix fmt` | alle `.nix`-bestanden formatteren                      |

## TODO

- [ ] Add nixos lsp to nvim from Tony's config
