#!/bin/bash
# validator.sh — git-remotes-collaboration / 02-cloning-repositories / git-inspect-remote
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/remote-details.txt"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify remote-details.txt exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you save the output of 'git remote -v'?"
  exit 1
fi

# Verify file contains origin and the remote path
if ! grep -q "origin" "$FILE" || ! grep -q "git-remote-server.git" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain remote origin details mapping to 'git-remote-server.git'."
  exit 1
fi

echo "PASS: Remote repository details inspected and recorded successfully!"
exit 0
