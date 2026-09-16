{ pkgs, pkgs-unstable, ... }:

{
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  home.packages = with pkgs; [
    pkgs-unstable.dotnet-sdk_10
    roslyn-ls
    omnisharp-roslyn
    pkgs-unstable.csharpier # C# code formatter
    dotnet-ef # Entity Framework CLI
    jetbrains.rider # .NET IDE
  ];
}
