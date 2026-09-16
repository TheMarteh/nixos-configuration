{ pkgs, pkgs-unstable, ... }:

let
  dotnet = pkgs-unstable.dotnet-sdk_10;
in
{
  # Globale SDK zodat Rider en losse `dotnet` commando's werken buiten een devShell.
  # Projecttools (dotnet-ef, csharpier, roslyn-ls) staan in templates/dotnet.
  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet}/share/dotnet";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  home.packages = [
    dotnet
    pkgs.jetbrains.rider
  ];
}
