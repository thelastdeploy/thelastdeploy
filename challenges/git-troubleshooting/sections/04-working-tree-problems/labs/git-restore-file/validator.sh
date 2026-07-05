#!/bin/bash
# validator.sh — git-troubleshooting / 04-working-tree-problems / git-restore-file
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/app.js"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify file exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found."
  exit 1
fi

# Verify no modifications in app.js
if [ -n "$(git -C "$REPO_DIR" diff "$FILE")" ]; then
  echo "FAIL: File '$FILE' still has uncommitted changes."
  exit 1
fi

# Verify content matches stable code
CONTENT=$(cat "$FILE")
if [ "$CONTENT" != 'console.log("stable code");' ]; then
  echo "FAIL: File '$FILE' contains '$CONTENT' (expected: 'console.log(\"stable code\");')."
  exit 1
fi

echo "PASS: Tracked file restored successfully to stable commit!"
exit 0
