{
  description = "Flutter (Linux desktop) development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # Build tools
        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          pkg-config
        ];

        # Libraries voor native plugins (bijv. flutter_secure_storage);
        # mkShell zet PKG_CONFIG_PATH hier automatisch voor.
        buildInputs = with pkgs; [
          gtk3
          glib
          libsecret
          pcre2
          xz
        ];
      };
    };
}
