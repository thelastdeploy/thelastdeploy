#!/bin/bash
# validator.sh — git-troubleshooting / 05-accidental-mistakes / git-remove-sensitive-file
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
GITIGNORE="$REPO_DIR/.gitignore"
PASSWORD="$REPO_DIR/password.txt"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify commit count is exactly 2 (proves they amended)
COMMIT_COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COMMIT_COUNT" -ne 2 ]; then
  echo "FAIL: Repository has $COMMIT_COUNT commits (expected: 2). Did you amend your last commit?"
  exit 1
fi

# Verify .gitignore exists
if [ ! -f "$GITIGNORE" ]; then
  echo "FAIL: .gitignore file not found."
  exit 1
fi

# Verify .gitignore ignores password.txt
if ! grep -q "password.txt" "$GITIGNORE"; then
  echo "FAIL: .gitignore does not contain 'password.txt'."
  exit 1
fi

# Verify password.txt is untracked in HEAD
if git -C "$REPO_DIR" ls-tree -r HEAD --name-only | grep -q "password.txt"; then
  echo "FAIL: 'password.txt' is still tracked in the latest commit. Did you run git rm --cached?"
  exit 1
fi

# Verify password.txt still exists in working tree (they didn't delete it physically, just cached)
if [ ! -f "$PASSWORD" ]; then
  echo "FAIL: 'password.txt' was physically deleted. You should untrack it from Git but preserve it in the working tree."
  exit 1
fi

# Verify working tree is clean
if [ -n "$(git -C "$REPO_DIR" status --porcelain | grep -v "password.txt")" ]; then
  echo "FAIL: Working tree or staging index has uncommitted modifications."
  exit 1
fi

echo "PASS: Sensitive file removed from commit history and ignored successfully!"
exit 0
