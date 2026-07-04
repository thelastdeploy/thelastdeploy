#!/bin/bash
# validator.sh — git-branching / 05-deleting-and-cleaning-branches / git-list-branches
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/branches.txt"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify branches.txt exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you save the output of 'git branch'?"
  exit 1
fi

# Verify file contains all expected branches
for BRANCH in "feature-login" "feature-payment" "bugfix-header"; do
  if ! grep -q "$BRANCH" "$FILE"; then
    echo "FAIL: File '$FILE' does not contain reference to branch '$BRANCH'."
    exit 1
  fi
done

# Verify file contains either main or master
if ! grep -qE "(main|master)" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain reference to default branch ('main' or 'master')."
  exit 1
fi

echo "PASS: Branch list saved and verified successfully!"
exit 0
