#!/bin/bash
# validator.sh — git-remotes-collaboration / 05-working-with-remote-branches / git-delete-remote-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify feature-trash does NOT exist on the remote repository
if git -C "$REMOTE_PATH" show-ref --verify refs/heads/feature-trash &>/dev/null; then
  echo "FAIL: Remote branch 'feature-trash' still exists on the server. Did you run 'git push origin --delete feature-trash'?"
  exit 1
fi

echo "PASS: Remote branch deleted successfully!"
exit 0
