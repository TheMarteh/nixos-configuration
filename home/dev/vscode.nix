{ pkgs, pkgs-unstable, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode.fhsWithPackages (
      ps: with ps; [
        # .NET SDK and runtime for debugging
        pkgs-unstable.dotnet-sdk_10

        # Required for vsdbg (the .NET debugger)
        icu
        openssl
        zlib
        curl

        # Common build dependencies
        gcc
        glibc

        # Flutter development
        flutter
        cmake
        ninja
        pkg-config
        gtk3
        glib
        libsecret
        pcre2
        xz
      ]
    );

    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      ms-dotnettools.vscode-dotnet-runtime
    ];
    mutableExtensionsDir = true;
  };
}
