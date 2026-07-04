#!/bin/bash
# validator.sh — git-history-and-recovery / 04-revert / git-revert-bad-commit
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/app.config"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify commit count is exactly 4
COMMIT_COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COMMIT_COUNT" -ne 4 ]; then
  echo "FAIL: Repository has $COMMIT_COUNT commits (expected: 4). Did you run git revert?"
  exit 1
fi

# Verify the latest commit message starts with Revert
MSG=$(git -C "$REPO_DIR" log -1 --format="%B")
if ! echo "$MSG" | grep -q -i "revert"; then
  echo "FAIL: The latest commit message '$MSG' does not indicate a revert."
  exit 1
fi

# Verify file contents
if [ ! -f "$FILE" ]; then
  echo "FAIL: Config file '$FILE' not found."
  exit 1
fi

if grep -q "api_key" "$FILE"; then
  echo "FAIL: File '$FILE' still contains the API key configuration."
  exit 1
fi

if ! grep -q "db_logging=true" "$FILE" || ! grep -q "port=8080" "$FILE"; then
  echo "FAIL: File '$FILE' is missing expected configurations (db_logging or port)."
  exit 1
fi

echo "PASS: Bad commit reverted successfully!"
exit 0
