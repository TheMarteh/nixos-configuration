{
  description = "NixOS install (steal)";
  inputs = {
    # Latest stable branch of nixpkgs, used for version rollback
    # The current latest version is 25.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Latest unstable nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      zen-browser,
      ...
    }:
    let
      system = "x86_64-linux";

      # Maak pkgs-unstable beschikbaar
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # `nix fmt` formatteert alle .nix-bestanden
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      # Projecttemplates: `nix flake init -t ~/nixos-configuration#dotnet`
      templates = {
        dotnet = {
          path = ./templates/dotnet;
          description = ".NET devShell (dotnet-ef, csharpier, roslyn-ls) met direnv";
        };
        flutter = {
          path = ./templates/flutter;
          description = "Flutter Linux build-dependencies met direnv";
        };
      };

      nixosConfigurations = {
        nixos-steal = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./hosts/nixos-steal
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.steal = import ./home;
                backupFileExtension = "backup";

                extraSpecialArgs = {
                  inherit pkgs-unstable;
                  inherit zen-browser;
                };
              };
            }
          ];
        };
      };
    };
}
