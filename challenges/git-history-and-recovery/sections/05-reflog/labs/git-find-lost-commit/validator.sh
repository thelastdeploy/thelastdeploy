#!/bin/bash
# validator.sh — git-history-and-recovery / 05-reflog / git-find-lost-commit
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/lost-hash.txt"
CORRECT_FILE="$REPO_DIR/.correct-hash"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify lost-hash.txt exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Please output the lost commit hash to '$FILE'."
  exit 1
fi

# Read hashes
USER_HASH=$(tr -d '[:space:]' < "$FILE")
CORRECT_HASH=$(tr -d '[:space:]' < "$CORRECT_FILE")

# Compare prefix (at least 7 chars)
if [ ${#USER_HASH} -lt 7 ]; then
  echo "FAIL: The hash entered in '$FILE' is too short (must be at least 7 characters)."
  exit 1
fi

if [[ "$CORRECT_HASH" != "$USER_HASH"* ]] && [[ "$USER_HASH" != "$CORRECT_HASH"* ]]; then
  echo "FAIL: The hash '$USER_HASH' does not match the correct lost commit hash."
  exit 1
fi

echo "PASS: Correct lost commit hash identified and recorded!"
exit 0
