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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
    system = "x86_64-linux";
    
    # Maak pkgs-unstable beschikbaar
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    in
        {
    nixosConfigurations =  {
      nixos-steal = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.steal = import ./home.nix;
              backupFileExtension = "backup";

              extraSpecialArgs = {
                inherit pkgs-unstable;
              };
            };
          }
        ];
      };
    };
  };
}
