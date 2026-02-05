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

### No approval needed (read-only / non-destructive)
Claude MAY freely run without asking:
- read any file in the repo or filesystem
- search the codebase (grep, glob, find)
- run web searches and fetch web pages
- query the nix store (nix-store -q*, nix flake show, nix flake metadata, nix eval)
- run nix flake check, nix build, nixos-rebuild dry-activate / test
- show git status / diff / log
- run alejandra / nix fmt (formatting only)

### Approval needed (writes / mutations)
Claude MUST ask before:
- creating, editing, or deleting files
- adding or removing modules
- running home-manager switch
- running nixos-rebuild switch or boot
- committing, pushing, rebasing, or force-pushing
- deleting branches or tags
- modifying Disko / partitioning / filesystem layout
- deleting snapshots or subvolumes
- touching secrets or credentials
- any other destructive system commands

---

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

## Git Usage

### Branch Management

**Main Branches**:
- `main`: Stable, tested configurations
- Feature branches: For development and testing (e.g., `install`, `feature/plasma-config`)

**Branch Operations**:
- Stay on current branch unless explicitly instructed to switch
- Create feature branches for experimental changes: `git checkout -b feature/description`
- Never delete branches without approval
- Keep branch names descriptive and lowercase with hyphens

### Commit Message Conventions

Follow conventional commits format:

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature or module
- `fix`: Bug fix or correction
- `refactor`: Code restructuring without behavior change
- `docs`: Documentation updates
- `style`: Formatting, theming changes
- `chore`: Maintenance tasks (dependency updates, cleanup)
- `config`: Configuration changes

**Examples**:
- `feat(plasma): add custom keyboard shortcuts`
- `fix(nixvim): resolve LSP configuration error`
- `chore(flake): update nixpkgs to 25.11`
- `config(system): enable bluetooth module`

**Commit Message Rules**:
- Focus on WHAT changed and WHY, not HOW it was created
- Do NOT include references to Claude Code, AI generation, or automated tools
- Remove any footers like "Generated with Claude Code" or "Co-Authored-By: Claude"
- Keep messages professional and tool-agnostic
- Commit history should reflect project changes, not development methodology

### Commit Workflow

**Before Committing**:
1. Format code: `alejandra .`
2. Check build: `sudo nixos-rebuild test --flake .#nixos`
3. Review changes: `git diff`
4. Stage relevant files: `git add <files>`

**Creating Commits**:
- Commit logical units of work (one feature/fix per commit)
- Always wait for explicit user approval before committing
- After successful rebuild, Claude will propose 1-3 commit messages
- User must explicitly say "commit" or "yes, commit" to proceed

**Never Commit**:
- Broken configurations
- Untested changes
- Secrets or credentials
- Generated files (hardware-configuration.nix changes require review)

### Push/Pull Policy

**Pulling**:
- Pull before starting new work: `git pull origin main`
- Use rebase to keep history clean: `git pull --rebase`

**Pushing**:
- NEVER push without explicit user approval
- Always push to feature branches first
- Never force-push to `main`
- Force-push to feature branches only with approval: `git push --force-with-lease`

### Merge/Rebase Strategy

**For Feature Branches**:
- Rebase on main to keep history linear: `git rebase main`
- Squash commits if needed before merging: `git rebase -i main`

**For Main Branch**:
- Merge feature branches with: `git merge --no-ff feature/name`
- Keep merge commits for features
- Fast-forward for small fixes

**Never Without Approval**:
- Interactive rebase
- History rewriting (amend, reset, rebase) on pushed commits
- Merge to main branch

### Common Operations

**Status Check**:
```bash
git status              # Check working tree
git log --oneline -10   # View recent commits
git diff                # View unstaged changes
git diff --staged       # View staged changes
```

**Stashing**:
```bash
git stash               # Save work in progress
git stash pop           # Restore stashed changes
git stash list          # View all stashes
```

**Undoing Changes**:
```bash
git restore <file>      # Discard unstaged changes
git restore --staged <file>  # Unstage file
git reset HEAD~1        # Undo last commit (keep changes)
```

**Viewing History**:
```bash
git log --graph --oneline --all  # Visual branch history
git show <commit>                # Show specific commit
git blame <file>                 # See line-by-line authorship
```

### After Changes Checklist

When Claude makes configuration changes:

1. ✅ Show `git status`
2. ✅ Show `git diff` for modified files
3. ✅ List all files changed
4. ✅ Report build/test results
5. ✅ Propose 1-3 commit messages following conventions
6. ⏸️ **WAIT** for explicit commit approval
7. ⏸️ **WAIT** for explicit push approval (if applicable)

### Emergency Procedures

**If Build Breaks**:
1. Don't commit
2. Review git diff to identify issues
3. Restore last working state if needed: `git restore .`
4. Check previous generation: `nixos-rebuild --list-generations`

**If Accidentally Staged**:
```bash
git restore --staged .  # Unstage everything
```

**If Need to Abort Merge**:
```bash
git merge --abort
```

---

## NixOS-specific guardrails

- Prefer nixos-rebuild dry-activate over switch.
- Avoid touching Disko unless asked.
- Never auto-garbage-collect or delete generations.
- Avoid removing boot entries.
- Keep changes minimal.
- **Display server awareness**: When making or suggesting changes that are relevant to the display server (e.g. compositing, GPU, windowing, desktop environment, app config that differs between X11 and Wayland), first check which one is in use. Look at `system/wm/` for the active session file (currently `x11.nix`; a `wayland.nix` may be added later) and, if needed, confirm at runtime with `echo $WAYLAND_DISPLAY` (non-empty = Wayland, empty = X11). Tailor suggestions and configs accordingly — do not assume X11.

---

## If unsure
Ask ONE focused question, otherwise proceed conservatively.

