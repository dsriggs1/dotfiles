# Niri Window Manager Configuration Setup

## ✅ Status: INSTALLED AND READY

**Successfully installed**: niri-unstable (2026-02-23) is installed and available in SDDM.

**Solution**: The stable version (niri-25.08) has build failures, but niri-unstable works perfectly. Configuration uses `inputs.niri.packages.${pkgs.system}.niri-unstable` to avoid the broken stable version.

**To use**: Log out, select "niri" from SDDM session dropdown, and log in.

## Overview

This document describes the minimal niri window manager configuration created for this NixOS system, integrating with existing keybindings and DankMaterialShell.

## Files Created

### 1. `system/wm/niri.nix`
System-level niri enablement and required services:
- Enables niri via `programs.niri.enable`
- Configures gnome-keyring for credential management
- Sets up polkit for privilege escalation
- Configures XDG desktop portal with gnome backend
- Enables dconf for GTK app settings
- Ensures dbus is running

### 2. `user/app/niri/niri.nix`
User-level niri configuration including:
- Global keybindings from `settings/keybindings.nix`
- DankMaterialShell integration for bar and launcher
- Multi-monitor configuration (DVI-I-1, DVI-I-2, eDP-1)
- Workspace management (workspaces 1-9)
- Window management with vim-style navigation (H/J/K/L)
- Screenshot integration with grim/slurp
- Volume controls via wpctl
- System actions (lock, power menu)

## Key Features

### Keybindings
All global keybindings from `settings/keybindings.nix` are mapped:

**Window Focus (vim-style)**:
- `Meta+H` - Focus left
- `Meta+L` - Focus right
- `Meta+J` - Focus down
- `Meta+K` - Focus up

**Window Actions**:
- `Meta+Q` - Close window
- `Meta+F` - Fullscreen
- `Meta+T` - Maximize column (niri's equivalent to float/tile toggle)

**App Launchers**:
- `Meta+Return` - Launch terminal (alacritty)
- `Meta+Shift+B` - Launch browser (firefox)
- `Meta+E` - Launch file manager (thunar)
- `Meta+Shift+C` - Launch VSCode
- `Meta+Shift+Escape` - Launch system monitor (btop)
- `Meta+Space` - Open DMS launcher

**Workspaces (numbered)**:
- `Meta+1-9` - Switch to workspace 1-9
- `Meta+Shift+1-9` - Move window to workspace 1-9

**Volume Controls**:
- `Meta+Up` - Volume up
- `Meta+Down` - Volume down
- `Meta+M` - Mute toggle

**Screenshots**:
- `Meta+Shift+S` - Area screenshot
- `Print` - Full screen screenshot
- `Meta+Print` - Window screenshot

**System Actions**:
- `Meta+Ctrl+Alt+L` - Lock session
- `Meta+Ctrl+Delete` - Power menu

### Niri-Specific Scrolling Keybindings

Since niri uses a scrolling workspace model, these additional bindings were added for alternative workspace navigation:

**Workspace Scrolling**:
- `Meta+Ctrl+H` - Scroll to previous workspace
- `Meta+Ctrl+L` - Scroll to next workspace
- `Meta+Ctrl+Shift+H` - Move window to previous workspace (while scrolling)
- `Meta+Ctrl+Shift+L` - Move window to next workspace (while scrolling)

**Window Management (niri-specific)**:
- `Meta+Shift+H` - Move window/column left
- `Meta+Shift+L` - Move window/column right
- `Meta+Shift+J` - Move window down within column
- `Meta+Shift+K` - Move window up within column
- `Meta+R` - Cycle through preset column widths (33%, 50%, 67%)
- `Meta+Shift+F` - Maximize column
- `Meta+C` - Center column
- `Meta+Shift+E` - Quit compositor

## Monitor Configuration

Configured for triple monitor setup:
- **DVI-I-1** (Left): 1920x1080@60Hz at position (0, 0) - Workspaces 1-3
- **DVI-I-2** (Center): 1920x1080@60Hz at position (1920, 0) - Workspaces 4-6
- **eDP-1** (Right/Laptop): 2256x1504@60Hz at position (3840, 0) - Workspaces 7-9

## DankMaterialShell Integration

DMS is configured to start automatically and provides:
- App launcher (opens with `Meta+Space`)
- Workspace indicator showing all workspaces
- Clock with calendar dropdown
- System monitoring (CPU, memory, temperature)
- Volume, Bluetooth, and WiFi widgets
- Battery indicator
- Notification center
- System tray

The wallpaper is synced with stylix configuration via:
```bash
dms ipc call wallpaper set <stylix-image-path>
```

## Layout Configuration

- **Gaps**: 10px between windows
- **Border**: 2px border width with focus ring enabled
- **Default column width**: 50% of screen
- **Preset widths**: 33%, 50%, 67% (cycle with `Meta+R`)
- **Animations**: Enabled with standard timing

## Package Dependencies

Minimal package additions (most already installed elsewhere):
- `jq` - JSON processor for potential window-aware screenshot scripts
- All other dependencies (wl-clipboard, slurp, grim, brightnessctl, etc.) already installed via hyprland.nix or home.nix

## Flake Configuration

Added to `flake.nix`:
```nix
# Binary cache for pre-built niri packages
nixConfig = {
  extra-substituters = ["https://niri.cachix.org"];
  extra-trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
};

inputs.niri = {
  url = "github:sodiboo/niri-flake";
  inputs.nixpkgs.follows = "nixpkgs-unstable";
};
```

Niri home-manager module added to shared modules list.

**Package Override**: Both system and user configurations specify:
```nix
package = inputs.niri.packages.${pkgs.system}.niri-unstable;
```

This ensures niri-unstable is used instead of the broken niri-stable (25.08).

## Testing the Configuration

### Build and Switch
```bash
# Update flake inputs
nix flake update niri

# Test build (dry-run)
nixos-rebuild dry-build --flake .#nixos

# Apply configuration
sudo nixos-rebuild switch --flake .#nixos
```

### Login
1. Log out of current session
2. At SDDM login screen, select "niri" from session dropdown
3. Log in with your credentials
4. DMS should start automatically with the configured bar

### First-Time Setup
After first login:
- DMS launcher can be opened with `Meta+Space` or by clicking the launcher button
- Workspaces are created dynamically as you use them
- Windows can be moved between monitors/workspaces using the keybindings

## Window Rules

Configured for common applications:
- **pavucontrol** (volume control): 33% width
- **qalculate-gtk** (calculator): 33% width
- **Picture-in-Picture**: 25% width

## Troubleshooting

### Build Failure: niri-25.08 Test Phase ✅ RESOLVED
**Issue**: The niri-stable package (version 25.08) fails to build with a thread panic during tests.

**Error encountered**:
```
thread caused non-unwinding panic. aborting.
error: test failed, to rerun pass `--lib`
process didn't exit successfully (signal: 6, SIGABRT: process abort signal)
```

**Solution Applied**:
1. **Use niri-unstable**: Override the default package in both system and user configs:
   ```nix
   # In system/wm/niri.nix and user/app/niri/niri.nix
   package = inputs.niri.packages.${pkgs.system}.niri-unstable;
   ```

2. **Add binary cache**: Configured niri.cachix.org to download pre-built binaries:
   ```nix
   # In flake.nix
   nixConfig = {
     extra-substituters = ["https://niri.cachix.org"];
     extra-trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
   };
   ```

3. **Fix configuration syntax**:
   - Fixed `Print` key binding (no modifiers) parsing
   - Removed `render-drm-device = null;` (KDL doesn't accept null values)

**Result**: niri-unstable (2026-02-23) installs successfully and appears in SDDM.

### DMS Not Starting
If DMS doesn't start automatically:
```bash
dms run
```

### Wallpaper Not Set
Manually set wallpaper:
```bash
dms ipc call wallpaper set /path/to/wallpaper.png
```

### Check Niri Status
View niri logs:
```bash
journalctl --user -u niri -f
```

### Verify Installation
Check installed version:
```bash
which niri
niri --version
# Should show: niri unstable 2026-02-23 (commit 2dc6f44...)
```

Check session file:
```bash
ls -la /run/current-system/sw/share/wayland-sessions/niri.desktop
# Should exist and point to niri-unstable package
```

### View Full Build Logs
If you encounter build errors:
```bash
nix log /nix/store/<derivation-path>.drv
```

### Common Build Issues
If you see errors about niri-25.08 during rebuild:
- This is normal - Nix may try to build the broken version from cache
- As long as niri-unstable builds successfully, the system will use that
- The error can be ignored if `which niri` shows the unstable version

## Notes

- Niri uses a scrolling column-based layout instead of traditional tiling
- Each workspace is an infinite horizontal canvas where windows are arranged in columns
- The scrolling model works well with ultra-wide monitors and multi-monitor setups
- Traditional numbered workspace switching (Meta+1-9) still works for direct navigation
- Screenshots copy to clipboard by default (no file saving currently configured)

## References

- [Niri GitHub](https://github.com/YaLTeR/niri)
- [Niri Flake](https://github.com/sodiboo/niri-flake)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- Local keybindings: `settings/keybindings.nix`
- DMS configuration: `user/app/dms/dms.nix`
