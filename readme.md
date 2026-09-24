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
| `nrb` | rebuild naar de volgende boot (zie home/shell.nix)         |
| `nrbu` | `nfu` + `nrb` in één keer                                 |
| `nfu` | `flake.lock` updaten                                       |
| `nix fmt` | alle `.nix`-bestanden formatteren                      |

## Thema's

Het palet staat in `theme/palettes/`; `theme/render.nix` vertaalt er de config
van elke app uit. Home-manager bouwt ze allemaal naar `~/.config/themes/<naam>/`
en `theme-set` verzet de symlink `~/.config/current-theme`.

```sh
theme-set            # rofi-menu met de beschikbare thema's
theme-set nord       # direct
theme-set --list
```

Waybar, rofi, swaync, Hyprland, alacritty, hyprlock, swayosd, btop, bat en
starship volgen meteen. De virtuele console, tuigreet en GTK/Qt niet: die staan
vast bij de build en volgen pas na een `nrs`.

## Eigen commando's

| Commando | Wat |
| -------- | --- |
| `sysmenu` | het systeemmenu (SUPER+SPACE), ook via de knop links in waybar |
| `power-menu` | vergrendelen/slaapstand/uitloggen/herstarten/afsluiten (SUPER+CTRL+SHIFT+P), ook onder Systeem in het menu |
| `theme-set` | wissel van thema zonder rebuild |
| `tui-modal <class> <cmd>` | open/sluit een zwevende terminal met een TUI |
| `screenshot [region\|window\|output]` | schermafbeelding via satty naar klembord en schijf |
| `screenrecord [--status]` | schermopname starten/stoppen |
| `clipboard-history` | klembordgeschiedenis via rofi |
| `screensaver` / `present-mode` | screensaver nu, of het scherm juist aanlaten |

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
