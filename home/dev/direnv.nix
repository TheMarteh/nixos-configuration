{ ... }:

{
  # Laadt automatisch de devShell van een project bij `cd` (via .envrc met `use flake`).
  # Nieuw project: `nix flake init -t ~/nixos-configuration#dotnet` (of #flutter), dan `direnv allow`.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
