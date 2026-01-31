# NixOS Module Options Reference

This document provides quick reference to the module options used in this configuration to help prevent configuration errors.

**Official NixOS Documentation**: https://wiki.nixos.org/wiki/NixOS_Wiki

---

## NixOS Core Options

**Documentation**: https://search.nixos.org/options

NixOS provides thousands of configuration options for the base system and packages. The complete options reference is available in `docs/module-options/nixos-options.json` (733KB).

**Key Option Categories**:
- `boot.*` - Boot loader and kernel configuration
- `networking.*` - Network configuration
- `services.*` - System services (systemd, databases, web servers, etc.)
- `hardware.*` - Hardware-specific settings
- `security.*` - Security and authentication
- `systemd.*` - Systemd units and services
- `environment.*` - System-wide environment variables and packages
- `users.*` - User and group management
- `virtualisation.*` - VM and container configuration

**Search options online**: https://search.nixos.org/options

**Full options**: See `docs/module-options/nixos-options.json`

---

## Stylix (System Theming)

**Documentation**: https://stylix.danth.me/options/nixos.html

**Key Options**:
- `stylix.enable` - Enable stylix theming
- `stylix.image` - Base image for color scheme generation (currently: `system/style/lake-sunrise.jpg`)
- `stylix.base16Scheme` - Base16 color scheme override
- `stylix.polarity` - "light" or "dark" theme
- `stylix.fonts.monospace.*` - Monospace font configuration
- `stylix.fonts.sansSerif.*` - Sans-serif font configuration
- `stylix.fonts.serif.*` - Serif font configuration
- `stylix.cursor.*` - Cursor theme configuration
- `stylix.opacity.*` - Application opacity settings
- `stylix.targets.*` - Enable/disable theming for specific applications

**Full options**: See `docs/module-options/stylix-options.json`

---

## Disko (Disk Partitioning)

**Documentation**: https://github.com/nix-community/disko

**Key Options**:
- `disko.devices.disk.<name>` - Physical disk configuration
- `disko.devices.disk.<name>.type` - Device type (e.g., "disk")
- `disko.devices.disk.<name>.content` - Partition table and content configuration

**⚠️ WARNING**: Disko is DESTRUCTIVE and only used during initial installation. Never modify without explicit approval.

**Current config**: `disko/btrfs-subvolumes.nix` (LVM + btrfs with subvolumes for /, /home, /persist, /nix)

---

## Home Manager

**Documentation**: https://nix-community.github.io/home-manager/

Home Manager manages user-level configuration. All user configs are in `user/app/`.

**Common patterns**:
- Many options now use `settings` blocks (e.g., `programs.git.settings.user.name`)
- Some use profile-based config (e.g., `programs.vscode.profiles.default`)

---

## Plasma Manager (KDE Plasma Configuration)

**Documentation**: https://nix-community.github.io/plasma-manager/

**Key Options**:
- `programs.plasma.enable` - Enable plasma-manager
- `programs.plasma.workspace.theme` - Plasma theme
- `programs.plasma.workspace.colorScheme` - Color scheme
- `programs.plasma.workspace.cursor.*` - Cursor configuration
- `programs.plasma.shortcuts.*` - Keyboard shortcuts
- `programs.plasma.configFile.*` - Direct KDE config file manipulation
- `programs.plasma.panels` - Panel configuration
- `programs.plasma.windows.rules` - Window rules
- `programs.plasma.hotkeys` - Custom hotkeys

**Current config**: `user/app/plasma-manager/`

**Available options**: See `docs/module-options/plasma-manager-available.json`

---

## Firefox Addons

**Documentation**: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable

**Key Options**:
- `programs.firefox.enable` - Enable Firefox
- `programs.firefox.profiles.<name>.extensions` - List of extensions
  - Extensions come from: `pkgs.nur.repos.rycee.firefox-addons`
  - Browse: https://nur.nix-community.org/repos/rycee/
- `programs.firefox.profiles.<name>.settings` - Firefox preferences (about:config)
- `programs.firefox.profiles.<name>.search.engines` - Custom search engines
- `programs.firefox.profiles.<name>.search.force` - Force search config
- `programs.firefox.profiles.<name>.search.default` - Default search engine

**Current config**: `user/app/browser/firefox.nix`

---

## Nixvim (Neovim Configuration)

**Documentation**: https://nix-community.github.io/nixvim/

**Recent API Changes**:
- Many plugin options now require `settings` blocks
- CamelCase options converted to snake_case
- Example: `backgroundColour` → `settings.background_colour`

**LSP Server Names**:
- TypeScript: `ts_ls` (formerly `tsserver`)
- Lua: `lua_ls` (formerly `lua-ls`)

**Current config**: `neovim/` directory

---

## Common Patterns Across Modules

### Settings Blocks
Modern NixOS/home-manager modules increasingly use `settings` blocks:

```nix
# Old style
programs.foo.option = value;

# New style
programs.foo.settings.option = value;
```

### Profile-Based Configuration
Some modules use profiles:

```nix
programs.vscode.profiles.default = {
  extensions = [ ... ];
  userSettings = { ... };
};
```

### Snake Case Naming
Many options are moving from camelCase to snake_case:
- `autoReloadOnWrite` → `auto_reload_on_write`
- `backgroundColour` → `background_colour`
- `topDown` → `top_down`

---

## Extracted Option Files

Raw JSON dumps of available options:
- `nixos-options.json` - Complete NixOS core options (733KB)
- `stylix-options.json` - Full stylix options
- `home-manager-options.json` - Home-manager module options
- `plasma-manager-available.json` - Plasma-manager available options
- `programs-list.json` - List of all available programs

---

## Tips for AI Assistance

When working with these modules:
1. **Always check the official documentation** links above for current API
2. **Refer to extracted JSON files** for available options
3. **Look at existing config files** in this repo for working examples
4. **Test with `nixos-rebuild test`** before switching
5. **Be aware of API migrations** - many modules are moving to `settings` blocks
