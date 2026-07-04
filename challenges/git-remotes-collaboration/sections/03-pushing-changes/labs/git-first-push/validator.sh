#!/bin/bash
# validator.sh — git-remotes-collaboration / 03-pushing-changes / git-first-push
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "main" ] && [ "$ACTIVE_BRANCH" != "master" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master'). Please switch to main/master."
  exit 1
fi

# Verify local commits have been pushed to origin (remote HEAD equals local HEAD)
LOCAL_HEAD=$(git -C "$REPO_DIR" rev-parse HEAD)
REMOTE_HEAD=$(git -C "$REPO_DIR" rev-parse "origin/$ACTIVE_BRANCH" 2>/dev/null || echo "")

if [ -z "$REMOTE_HEAD" ]; then
  echo "FAIL: Remote branch 'origin/$ACTIVE_BRANCH' not found."
  exit 1
fi

if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
  echo "FAIL: Your local commits have not been pushed to remote branch yet."
  exit 1
fi

# Verify the file exists on the bare repository remote server HEAD
if ! git -C "$REMOTE_PATH" cat-file -e "HEAD:features.txt" 2>/dev/null; then
  echo "FAIL: The remote repository does not contain features.txt."
  exit 1
fi

echo "PASS: Changes successfully pushed to the remote repository!"
exit 0
