#!/usr/bin/env bash

set -e

EMAIL="$1"

if [ -z "$EMAIL" ]; then
  echo "Usage: $0 your_email@example.com"
  exit 1
fi

KEY_PATH="$HOME/.ssh/id_ed25519"

echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""

echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

echo "Adding SSH key to agent..."
ssh-add "$KEY_PATH"

echo "Public key:"
echo "----------------------------------------"
cat "${KEY_PATH}.pub"
echo "----------------------------------------"
echo "Copy the above public key to GitHub:"
echo "https://github.com/settings/keys -> New SSH key"

echo ""
echo "To test the connection after adding the key:"
echo "    ssh -T git@github.com"

