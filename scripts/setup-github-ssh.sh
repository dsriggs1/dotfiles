#!/usr/bin/env bash
# Setup script for GitHub SSH authentication
# This script is automatically run during home-manager activation if no SSH key exists

set -e

SSH_KEY="$HOME/.ssh/github"
SSH_PUB="$SSH_KEY.pub"

echo ""
echo "=========================================="
echo "   GitHub SSH Key Setup"
echo "=========================================="
echo ""

# Ensure .ssh directory exists with correct permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Check if key already exists
if [ -f "$SSH_KEY" ]; then
    echo "✓ SSH key already exists at $SSH_KEY"
    exit 0
fi

# Generate new key
echo "→ Generating new SSH key..."
ssh-keygen -t ed25519 -C "dsriggs1@gmail.com" -f "$SSH_KEY" -N "" -q
chmod 600 "$SSH_KEY"
chmod 644 "$SSH_PUB"

echo "✓ SSH key generated successfully!"
echo ""
echo "=========================================="
echo "   Add this public key to GitHub:"
echo "=========================================="
echo ""
cat "$SSH_PUB"
echo ""
echo "=========================================="
echo "   Next Steps:"
echo "=========================================="
echo "1. Copy the public key above"
echo "2. Visit: https://github.com/settings/ssh/new"
echo "3. Paste the key and give it a title"
echo "4. Click 'Add SSH key'"
echo "5. Test with: ssh -T git@github.com"
echo ""
echo "After adding to GitHub, update your dotfiles remote:"
echo "  cd ~/Downloads/dotfiles"
echo "  git remote set-url origin git@github.com:yourusername/dotfiles.git"
echo ""
