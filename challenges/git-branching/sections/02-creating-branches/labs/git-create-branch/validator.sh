#!/bin/bash
# validator.sh — git-branching / 02-creating-branches / git-create-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify branch feature-login exists
if ! git -C "$REPO_DIR" show-ref --verify refs/heads/feature-login &>/dev/null; then
  echo "FAIL: Branch 'feature-login' not found."
  exit 1
fi

echo "PASS: Branch 'feature-login' created successfully!"
exit 0
