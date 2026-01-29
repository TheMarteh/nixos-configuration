# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS configuration repository using Nix flakes and home-manager for declarative system and user configuration management. The system runs Hyprland (Wayland compositor) on an AMD CPU with NVIDIA GPU.

## Common Commands

**Note**: The following bash aliases are defined in home.nix:
- `nrs` - Rebuild and switch system configuration
- `nfu` - Update all flake inputs
- `btw` - Display "I use NixOS, btw"

### System Rebuild
```bash
# Rebuild and switch system configuration
sudo nixos-rebuild switch --flake ~/nixos-configuration#nixos-steal

# Using alias
nrs
```

### Flake Management
```bash
# Update all flake inputs
nix flake update --flake ~/nixos-configuration

# Using alias
nfu

# Show flake metadata
nix flake show
nix flake metadata
```

### Testing Changes
```bash
# Test configuration without switching (creates result symlink)
sudo nixos-rebuild test --flake ~/nixos-configuration#nixos-steal

# Build without activating
sudo nixos-rebuild build --flake ~/nixos-configuration#nixos-steal
```

### Garbage Collection
```bash
# Remove old generations
sudo nix-collect-garbage --delete-older-than 7d

# Remove all old generations
sudo nix-collect-garbage -d
```

**Note**: The store is auto-optimized (hard-linking identical files) via `nix.settings.auto-optimise-store = true`.

## Architecture

### Flake Structure (flake.nix)
- **Inputs**: Uses nixpkgs (25.11 stable), nixpkgs-unstable, and home-manager (release-25.11)
- **Outputs**: Single NixOS configuration named `nixos-steal`
- **Special Args**: `pkgs-unstable` is passed to home-manager for accessing bleeding-edge packages

### Configuration Files
- **flake.nix**: Entry point, defines inputs and outputs
- **configuration.nix**: System-level configuration (services, drivers, users)
- **home.nix**: User-level configuration via home-manager
- **hardware-configuration.nix**: Auto-generated hardware detection (do not manually edit)

### Mixed Package Sources
This configuration uses both stable and unstable nixpkgs:
- Most packages come from nixpkgs (25.11 stable)
- Specific packages use `pkgs-unstable` when newer versions are needed (e.g., swww, bolt-launcher, dotnet-sdk_10, vscode)
- Access unstable packages in home.nix via `pkgs-unstable.package-name`

### Dotfiles Management (home.nix)
Configuration files in `./config/` are symlinked to `~/.config/` using out-of-store symlinks (`config.lib.file.mkOutOfStoreSymlink`):
- **nvim**: Neovim configuration (Lua-based with lazy.nvim plugin manager)
- **hypr**: Hyprland compositor configuration (split into multiple .conf files)
- **waybar**: Status bar configuration
- **swaync**: Notification center configuration

The out-of-store symlink approach allows editing configs directly in `~/nixos-configuration/config/` without triggering a home-manager rebuild. Changes take effect immediately (app restart may be required).

### System Components
- **Display Server**: Wayland (Hyprland compositor)
- **Login Manager**: greetd with tuigreet
- **Audio**: PipeWire with PulseAudio compatibility
- **GPU**: NVIDIA proprietary drivers (open kernel modules enabled)
- **Virtualization**: Docker (rootless), libvirt/virt-manager, NVIDIA container toolkit
- **Services**: Ollama (CUDA acceleration), open-webui

### Development Environment
- **.NET**: dotnet-sdk_10 from unstable, with Roslyn LSP and OmniSharp
  - `DOTNET_ROOT` and telemetry opt-out configured in session variables
  - VSCode uses FHS wrapper with .NET SDK included for full compatibility
- **Android**: Android Studio, ADB tools, emulator configured via androidenv
  - Emulator instance: API 36, x86_64, Google APIs with Play Store
- **Flutter**: Configured with Wayland environment variables
- **Git**: Configured with user "TheMarteh" <martijnfs@me.com>
  - GitHub CLI (`gh`) with credential helper enabled
- **VSCode**: Uses FHS wrapper (`vscode.fhsWithPackages`) for .NET compatibility
  - Extensions: C# Dev Kit, OmniSharp, .NET Runtime
  - Mutable extensions directory enabled for synced extensions
- **Neovim**: Custom Lua configuration with LSP support (in ./config/nvim)
- **Claude Code**: Enabled via `programs.claude-code.enable = true`

### Theme System
- **GTK/GNOME apps**: Adwaita-dark theme
- **Qt/KDE apps**: adwaita-qt and adwaita-qt6
- **Consistent dark mode**: Environment variables set system-wide and per-user
- **Cursor/Icons**: Adwaita theme

## Important Notes

### State Version
Never change `system.stateVersion` (currently "25.05") or `home.stateVersion` unless you understand the data migration implications. This does NOT control package versions.

### Hardware Configuration
Do not manually edit `hardware-configuration.nix` - it's auto-generated. Make hardware-related overrides in `configuration.nix` instead.

### Home Manager Backups
home-manager creates `.backup` files when conflicting files exist (configured via `backupFileExtension`).

### Flake Inputs
When updating flake inputs, ensure home-manager release matches nixpkgs version to avoid compatibility issues.

### User vs System Packages
- System packages go in `configuration.nix` `environment.systemPackages` (minimal: vim, wget, curl, git, tmux)
- User packages go in `home.nix` `home.packages` (most development tools and GUI apps)

### NVIDIA Notes
- Using open-source NVIDIA kernel modules (`hardware.nvidia.open = true`)
- Container toolkit enabled for GPU access in Docker
- Video acceleration packages installed for hardware decoding

### Experimental Features
Flakes and nix-command are enabled system-wide in `configuration.nix`.

### Performance Optimizations
- **Auto-optimize store**: Enabled (`nix.settings.auto-optimise-store = true`) - automatically hard-links identical files
- **Download buffer**: Increased to 500MB (`download-buffer-size = 524288000`) for faster downloads
- **Trusted users**: root and steal can use extra Nix features without sudo

### Additional Services
- **Ollama**: AI model serving with CUDA acceleration (home-manager service)
- **Open WebUI**: Web interface for Ollama (system service)
- **KWallet**: KDE wallet service for credential management (user service)
- **swww**: Wallpaper daemon (from unstable, home-manager service)
