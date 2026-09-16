{
  description = ".NET development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dotnet = pkgs.dotnet-sdk_10;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          dotnet
          pkgs.dotnet-ef # Entity Framework CLI
          pkgs.csharpier # formatter
          pkgs.roslyn-ls # LSP (nvim)
        ];

        DOTNET_ROOT = "${dotnet}/share/dotnet";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      };
    };
}
