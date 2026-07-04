#!/bin/bash
# validator.sh — git-branching / 06-finish-a-feature / git-complete-feature-workflow
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/auth.js"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active branch is main or master
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "main" ] && [ "$ACTIVE_BRANCH" != "master" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master'). Please checkout your main/master branch."
  exit 1
fi

# Verify branch auth-feature does NOT exist anymore (should be deleted)
if git -C "$REPO_DIR" show-ref --verify refs/heads/auth-feature &>/dev/null; then
  echo "FAIL: Branch 'auth-feature' still exists. It should be deleted after merging."
  exit 1
fi

# Verify auth.js exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File 'auth.js' not found. Did you create and merge it?"
  exit 1
fi

# Verify auth.js content
CONTENT=$(cat "$FILE")
if [ "$CONTENT" != 'console.log("auth");' ]; then
  echo "FAIL: File 'auth.js' contains '$CONTENT' (expected: 'console.log(\"auth\");')."
  exit 1
fi

# Verify auth.js is tracked and committed on active branch
if ! git -C "$REPO_DIR" log --format="%B" | grep -q -i "auth"; then
  echo "FAIL: No commit matching feature implementation found in history."
  exit 1
fi

echo "PASS: Complete feature branch workflow executed successfully!"
exit 0
