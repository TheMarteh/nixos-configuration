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
templates/              devShell-templates voor projecten (dotnet, flutter)
```

Iets toevoegen: maak een nieuw `.nix`-bestand in de juiste map, voeg het toe aan
de `imports` in `default.nix` van die map en **`git add` het bestand**, anders
ziet de flake het niet.

## Commando's

| Alias | Wat                                                        |
| ----- | ---------------------------------------------------------- |
| `nrs` | rebuild + switch (via `nh`, toont eerst een pakketten-diff) |
| `nrsu` | `nfu` + `nrs` in één keer                                  |
| `nfu` | `flake.lock` updaten                                       |
| `nix fmt` | alle `.nix`-bestanden formatteren                      |

## Projecten: devShells + direnv

Build-tools en projectspecifieke tools staan niet globaal, maar per project in een
devShell. direnv laadt die automatisch zodra je de projectmap in `cd`t.

```sh
cd mijn-project
nix flake init -t ~/nixos-configuration#dotnet   # of #flutter
direnv allow
```

Pas daarna `flake.nix` in het project aan (extra pakketten, versies). Commit
`flake.nix`, `flake.lock` en `.envrc` mee in het project.

Globaal blijven alleen SDK's en IDE's (dotnet-sdk, flutter, Rider, VS Code,
Android Studio). Start een editor vanuit de projectmap als hij de tools uit de
devShell nodig heeft (bijv. `roslyn-ls` voor nvim).

## TODO

- [ ] Add nixos lsp to nvim from Tony's config
