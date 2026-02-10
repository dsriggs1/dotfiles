# KDE Wallet Auto-Unlock and WiFi Auto-Connect

## Quick Start

### Already Installed? Fix It Now
```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#nixos

# Reset wallet for auto-unlock
kwallet-reset

# Log out and back in
# Re-enter WiFi password once
# Done!
```

### Fresh Install?
No action needed! Wallet auto-unlocks on first login.

---

## Overview

Automated configuration to enable KDE Wallet auto-unlock at login and WiFi auto-connection using PAM integration. Includes the `kwallet-reset` tool for existing systems and automatic setup for fresh installs.

## Problem

When logging into KDE Plasma, users are prompted for a KDE Wallet password, preventing automatic WiFi connection. NetworkManager stores WiFi passwords in KDE Wallet for security, but without wallet unlock, the passwords can't be retrieved.

**Root Cause:** KDE Wallet password must match your login password exactly for PAM auto-unlock to work.

## Solution

### Automated Setup (Recommended)

The configuration includes:
1. **PAM Integration** - Auto-unlocks wallet using login password
2. **kwallet-reset Tool** - Resets wallet for existing systems
3. **Fresh Install Support** - Automatically configures new systems

### NixOS Configuration Files

**File: `system/security/pam.nix`**

```nix
{...}: {
  # PAM configuration for KDE Wallet integration
  # This enables automatic kwallet unlock at login
  security.pam.services = {
    sddm.enableKwallet = true;
    kde.enableKwallet = true;
  };
}
```

**File: `user/app/plasma-manager/kwallet.nix`**

```nix
{pkgs, lib, ...}: {
  programs.plasma = {
    configFile = {
      kwalletrc = {
        Wallet = {
          "First Use" = false;
          "Enabled" = true;
          "Prompt on Open" = false;
          "Use One Wallet" = true;
          "Default Wallet" = "kdewallet";
          "Close When Idle" = false;
          "Idle Timeout" = 10;
        };
      };
    };
  };

  # Helper script to reset KWallet for PAM auto-unlock
  home.packages = with pkgs; [
    (writeShellScriptBin "kwallet-reset" ''
      # Script backs up and resets wallet for PAM auto-unlock
    '')
  ];

  # Inform user about KWallet setup on fresh installs
  home.activation.kwalletSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Shows helpful message on fresh installs
  '';
}
```

**Import in `configuration.nix`:**

```nix
imports = [
  # ... other imports
  ./system/security/pam.nix
];
```

**Import in `user/app/plasma-manager/plasma.nix`:**

```nix
imports = [
  # ... other imports
  ./kwallet.nix
];
```

## Usage

### For Existing Systems (Already Installed)

If you already have NixOS installed and are experiencing wallet prompts:

1. **Rebuild your system:**
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

2. **Reset your wallet:**
   ```bash
   kwallet-reset
   ```
   This will:
   - Backup your current wallet (with timestamp)
   - Remove existing wallet files
   - Prepare for PAM to create a new wallet

3. **Log out and log back in**
   - PAM will create a new wallet using your login password
   - Wallet will unlock automatically
   - Re-enter WiFi password once (it'll be saved)

### For Fresh Installs

On a new NixOS installation:
1. Run installation as normal
2. On first login, PAM automatically creates wallet with login password
3. Wallet unlocks automatically on every subsequent login
4. Enter WiFi password once - it auto-connects thereafter

## How It Works

1. **PAM Integration**: When you log in via SDDM, the `pam_kwallet5.so` module uses your login password to unlock KDE Wallet
2. **Password Synchronization**: The `kwallet-reset` tool ensures wallet password matches login password by letting PAM create a fresh wallet
3. **Wallet Configuration**: Settings prevent prompts and ensure reliable auto-unlock
4. **WiFi Auto-Connect**: NetworkManager retrieves saved passwords from the unlocked wallet

## Verification

### Check KWallet Status

After logging in, verify auto-unlock is working:

```bash
# Check if kwallet is running
ps aux | grep kwalletd6

# Check PAM kwallet module is loaded
cat /etc/pam.d/login | grep kwallet

# Check NetworkManager connections
nmcli connection show

# Verify wallet directory
ls -la ~/.local/share/kwalletd/
```

**Expected behavior:**
- No wallet password prompt on login
- WiFi connects automatically
- `kwalletd6` process is running
- PAM module shows in `/etc/pam.d/login`

### Troubleshooting

**Still getting wallet prompts?**
```bash
# Verify PAM configuration
cat /etc/pam.d/login | grep pam_kwallet5.so

# Check wallet exists
ls ~/.local/share/kwalletd/kdewallet.kwl

# If wallet exists but prompts appear, run:
kwallet-reset
# Then log out and back in
```

**WiFi not auto-connecting?**
- Wallet may not be unlocked (check for password prompts)
- Password might not be saved (re-enter once after wallet reset)
- Connection might be user-specific (should be after wallet unlock works)

## Alternative Solutions

### Option 2: System-Wide WiFi Connections

Store WiFi passwords as system connections (bypasses kwallet entirely):

```nix
networking.networkmanager = {
  enable = true;
  wifi.powersave = false;  # Optional: disable power saving
  plugins = [];  # Disable kwallet plugin
};
```

Then reconnect to WiFi and choose "All Users" when saving.

**Trade-off:** All users on the system can see WiFi passwords.

### Option 3: Disable KWallet

Completely disable kwallet (loses credential storage for all KDE apps):

```nix
programs.plasma = {
  configFile = {
    kwalletrc = {
      Wallet = {
        "Enabled" = false;
      };
    };
  };
};
```

**Trade-off:** Apps can't securely store credentials (email, cloud sync, etc.).

### Option 4: Empty Wallet Password

Use KWallet with an empty password (no PAM needed):

Set wallet password to empty in KWallet Manager.

**Trade-off:** Anyone with access to your session can read stored passwords.

## Which Solution to Use?

### Recommended: PAM Auto-Unlock (Default)
**Use when:** Single-user system or users trust each other
- ✅ Secure (password-protected wallet)
- ✅ Automatic unlock
- ✅ Works for all KDE apps
- ✅ Easy maintenance with `kwallet-reset`

### System-Wide WiFi (Option 2)
**Use when:** Multiple users need same WiFi, don't trust each other
- ✅ No wallet needed
- ⚠️ Less secure (plaintext in system files)
- ⚠️ Doesn't help other KDE apps

### Empty Password (Option 4)
**Use when:** Single-user system, maximum convenience
- ✅ Very convenient
- ⚠️ No password protection
- ⚠️ Anyone with session access can read credentials

### Disabled Wallet (Option 3)
**Use when:** Don't use KDE apps that need credentials
- ⚠️ Least functional
- Only if you don't need credential storage at all

## Technical Details

### PAM Module Behavior

The `pam_kwallet5.so` module:
1. Intercepts login authentication
2. Receives your login password
3. Attempts to unlock `~/.local/share/kwalletd/kdewallet.kwl`
4. If wallet doesn't exist, creates it with login password
5. If password doesn't match, wallet remains locked

### Wallet File Structure

```
~/.local/share/kwalletd/
├── kdewallet.kwl              # Encrypted wallet file
├── kdewallet.salt             # Encryption salt
└── kdewallet_attributes.json  # Wallet metadata
```

### Fresh Install Flow

1. User installs NixOS with this configuration
2. SDDM login triggers PAM authentication
3. PAM calls `pam_kwallet5.so` in auth phase
4. No wallet exists, so PAM creates one
5. Wallet password = login password (automatic sync)
6. Session phase unlocks the new wallet
7. User never sees password prompts

## References

- [KDE Wallet - ArchWiki](https://wiki.archlinux.org/title/KDE_Wallet)
- [NixOS PAM Options](https://search.nixos.org/options?query=security.pam)
- [plasma-manager Configuration](https://github.com/pjones/plasma-manager)
- [kwallet-pam GitHub](https://github.com/KDE/kwallet-pam)
- [KDE Wallet Manager Documentation](https://userbase.kde.org/KDE_Wallet_Manager)
