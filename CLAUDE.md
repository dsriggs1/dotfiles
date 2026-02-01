# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS configuration repository using flakes, home-manager, and nixvim. The configuration is for a personal laptop running NixOS with a modular structure separating system-level and user-level configurations.

## Building and Deployment

### Initial System Installation
```bash
# Run the installation script (sets up disk partitioning with disko and clones repo)
./install.sh
```

### Rebuild System Configuration
```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#nixos

# Test configuration without activating (recommended before switching)
sudo nixos-rebuild test --flake .#nixos

# Build configuration for next boot
sudo nixos-rebuild boot --flake .#nixos
```

### Update Flake Inputs
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Format Nix Files
```bash
# Format all Nix files using alejandra
alejandra .
```

## Architecture

### Flake Structure
The `flake.nix` defines two primary configuration sets:
- **systemSettings**: System-level configuration (hostname, timezone, locale)
- **userSettings**: User-specific configuration (username, email, home directory, shell)

### Module Organization

**System-level modules** (`./system/`):
- `app/`: Service configurations (jellyfin, mysql, picom)
- `hardware/`: Hardware-specific configs (bluetooth)
- `security/`: Security services (firewall, VPN, blocky DNS, sshd)
- `style/`: Theming via stylix
- `wm/`: Window manager/desktop environment (X11)

**User-level modules** (`./user/app/`):
- `browser/`: Firefox configuration with addons
- `git/`: Git configuration
- `plasma-manager/`: KDE Plasma desktop settings (panels, shortcuts, window rules, hotkeys)
- `terminal/`: Shell configuration (nushell, starship, zoxide)
- `tmux/`: Tmux and tmuxinator
- `vscode/`: VSCode configuration

**Neovim configuration** (`./neovim/`):
- Uses nixvim for declarative Neovim configuration
- Modular plugin setup: LSP, completion, keymaps, options, conform (formatting)
- Plugins include: copilot, telescope, nvim-tree, fugitive, neogit, treesitter, avante

**Disk configuration** (`./disko/`):
- `btrfs-subvolumes.nix`: Defines disk partitioning with LVM and btrfs subvolumes
- Creates `/root`, `/home`, `/persist`, and `/nix` subvolumes
- Used during initial installation via disko

### Key Configuration Files

- `configuration.nix`: Main NixOS system configuration, imports all system modules
- `home.nix`: Home-manager configuration, imports all user modules
- `flake.nix`: Flake definition with inputs (nixpkgs, home-manager, stylix, nixvim, plasma-manager, firefox-addons, disko) and outputs
- `hardware-configuration.nix`: Auto-generated hardware-specific configuration

### Module Options Documentation

**IMPORTANT**: Before modifying module configurations, consult `docs/MODULE-OPTIONS.md` for:
- NixOS core options (`nixos-options.json` - 733KB complete reference)
- Available options for stylix, disko, home-manager, plasma-manager, firefox-addons, and nixvim
- Current API patterns (settings blocks, snake_case naming)
- Official documentation links
- Extracted JSON option files in `docs/module-options/`

This documentation helps prevent configuration errors and API mismatches. When in doubt about available options, check the JSON files before making changes.

### Important Patterns

1. **Dual Package Sets**: The configuration uses both stable (`pkgs-stable`) and regular (`pkgs`) nixpkgs channels. The main channel is `release-25.11`.

2. **Modular Imports**: Both system and user configurations use modular imports. When adding new functionality, create a separate `.nix` file and import it in the appropriate parent configuration.

3. **Media Server Setup**: The `jellyfin.nix` module demonstrates the pattern for multi-service media server configuration with shared permissions via a `media` group and tmpfiles.d directory creation.

4. **Stylix Theming**: The system uses stylix for unified theming across applications. The base image is `lake-sunrise.jpg` in `system/style/`.

5. **Special Args**: The flake passes `systemSettings` and `userSettings` as special arguments to modules, allowing centralized configuration of hostname, username, timezone, etc.

## Development Workflow

When modifying configurations:
1. Edit the relevant `.nix` file in the appropriate module directory
2. If change performs terminal command claude should test that the command works first in terminal before modifying the .nix file.
3. Test the configuration with `sudo nixos-rebuild test --flake .#nixos`
4. If successful, switch with `sudo nixos-rebuild switch --flake .#nixos`
5. Commit changes to git (currently on `install` branch)

## Notes

- The system uses nushell as the default shell (configured in `configuration.nix`)
- Automatic garbage collection runs daily, deleting generations older than 7 days
- The system enables experimental features: `nix-command` and `flakes`
- The main user is `sean` with groups: networkmanager, wheel, libvirtd, kvm, media
# Execution & Safety Rules

## Default permissions
Claude MAY:
- create or edit files
- add new modules
- refactor code
- run:
  - nix flake check
  - nix build
  - home-manager switch
  - nixos-rebuild dry-activate
  - nix fmt / alejandra
- show git status / diff
- propose commit messages

Claude MUST NOT without explicit user approval:
- run nixos-rebuild switch
- commit, push, rebase, or force-push
- delete branches or tags
- modify Disko / partitioning / filesystem layout
- delete snapshots or subvolumes
- touch secrets or credentials
- run destructive system commands

Claude SHOULD after any changes:
1) show `git diff`
2) list files modified
3) report build results
4) suggest a commit message
5) wait for confirmation before committing

---

## Git workflow

- Work on the current branch unless told otherwise.
- Never push without approval.
- After successful rebuilds:
  - present a short summary of changes
  - propose 1–3 commit messages
  - wait for explicit "commit" instruction.

---

## NixOS-specific guardrails

- Prefer nixos-rebuild dry-activate over switch.
- Avoid touching Disko unless asked.
- Never auto-garbage-collect or delete generations.
- Avoid removing boot entries.
- Keep changes minimal.

---

## If unsure
Ask ONE focused question, otherwise proceed conservatively.

