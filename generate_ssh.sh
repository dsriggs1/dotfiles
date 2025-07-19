#!/usr/bin/env bash

set -euo pipefail

EMAIL="${1:-}"
REPO_PATH="${2:-}"

if [[ -z "$EMAIL" ]]; then
  echo "Usage: $0 <your_email@example.com> [optional:/path/to/git/repo]"
  exit 1
fi

KEY_PATH="$HOME/.ssh/id_ed25519"

# Step 1: Generate SSH key
if [[ -f "$KEY_PATH" ]]; then
  echo "SSH key already exists at $KEY_PATH, skipping key generation."
else
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# Step 2: Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# Step 3: Print public key
echo
echo "👉 Your public SSH key (copy and add to GitHub -> https://github.com/settings/keys):"
echo "------------------------------------------------------------------------------------"
cat "${KEY_PATH}.pub"
echo "------------------------------------------------------------------------------------"

# Step 4: Optional - convert Git remote in specified repo
if [[ -n "$REPO_PATH" ]]; then
  echo
  echo "📁 Updating Git remote in repo: $REPO_PATH"

  if [[ ! -d "$REPO_PATH/.git" ]]; then
    echo "Error: $REPO_PATH does not appear to be a Git repository."
    exit 1
  fi

  cd "$REPO_PATH"
  OLD_URL=$(git remote get-url origin)

  if [[ "$OLD_URL" =~ ^https://github\.com/(.*)/(.*)(\.git)?$ ]]; then
    USER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SSH_URL="git@github.com:${USER}/${REPO}.git"

    echo "🔁 Converting remote from HTTPS to SSH: $SSH_URL"
    git remote set-url origin "$SSH_URL"
  else
    echo "Remote already uses SSH or unrecognized format, skipping remote update."
  fi
fi

# Step 5: Test connection
echo
echo "✅ All done! Test your connection with:"
echo "    ssh -T git@github.com"
echo
echo "Then try:"
echo "    git push"
