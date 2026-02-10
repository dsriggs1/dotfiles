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
      #!/usr/bin/env bash

      set -e

      WALLET_DIR="$HOME/.local/share/kwalletd"
      BACKUP_DIR="$HOME/.local/share/kwalletd-backup-$(date +%Y%m%d-%H%M%S)"

      echo "=== KWallet Reset Tool ==="
      echo "This will reset your KWallet to enable PAM auto-unlock."
      echo ""
      echo "What this does:"
      echo "1. Backs up your current wallet to: $BACKUP_DIR"
      echo "2. Removes the current wallet files"
      echo "3. On next login, PAM will create a new wallet using your login password"
      echo "4. You'll need to re-enter saved passwords (WiFi, etc.)"
      echo ""
      read -p "Continue? (y/N): " -n 1 -r
      echo

      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
      fi

      # Kill kwalletd if running
      echo "Stopping KWallet daemon..."
      killall kwalletd6 2>/dev/null || true
      killall kwalletd5 2>/dev/null || true
      sleep 1

      # Backup existing wallet
      if [ -d "$WALLET_DIR" ]; then
        echo "Backing up wallet to: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        cp -r "$WALLET_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true

        # Remove wallet files (keep directory)
        echo "Removing wallet files..."
        rm -f "$WALLET_DIR/kdewallet.kwl"
        rm -f "$WALLET_DIR/kdewallet.salt"
        rm -f "$WALLET_DIR/kdewallet_attributes.json"
      else
        echo "No existing wallet found."
      fi

      echo ""
      echo "✓ Done!"
      echo ""
      echo "IMPORTANT: On your next logout/login:"
      echo "  • PAM will automatically create a new wallet"
      echo "  • The wallet password will match your login password"
      echo "  • KWallet will unlock automatically without prompting"
      echo ""
      echo "You'll need to:"
      echo "  • Re-enter WiFi passwords (they'll be saved to the new wallet)"
      echo "  • Re-authenticate any apps that used KWallet"
      echo ""
      echo "Backup location: $BACKUP_DIR"
      echo ""
      echo "Log out and log back in to complete the setup."
    '')
  ];

  # Inform user about KWallet setup on fresh installs
  home.activation.kwalletSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    WALLET_FILE="$HOME/.local/share/kwalletd/kdewallet.kwl"

    if [ ! -f "$WALLET_FILE" ]; then
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "  KWallet Auto-Unlock: Ready for first login"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "On your next login, KWallet will be automatically"
      $DRY_RUN_CMD echo "created with your login password (via PAM)."
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "You can also run 'kwallet-reset' anytime to reset"
      $DRY_RUN_CMD echo "your wallet for auto-unlock."
      $DRY_RUN_CMD echo ""
    fi
  '';
}
