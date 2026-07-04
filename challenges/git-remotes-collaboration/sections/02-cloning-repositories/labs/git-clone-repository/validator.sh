#!/bin/bash
# validator.sh — git-remotes-collaboration / 02-cloning-repositories / git-clone-repository
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository directory exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR. Did you run 'git clone'?"
  exit 1
fi

# Verify remote origin URL points to REMOTE_PATH
REMOTE_URL=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_URL" ]; then
  echo "FAIL: Remote 'origin' is not configured."
  exit 1
fi

# Resolve paths to absolute to prevent discrepancy
ABS_REMOTE_URL=$(realpath "$REMOTE_URL" 2>/dev/null || echo "$REMOTE_URL")
ABS_REMOTE_PATH=$(realpath "$REMOTE_PATH" 2>/dev/null || echo "$REMOTE_PATH")

if [ "$ABS_REMOTE_URL" != "$ABS_REMOTE_PATH" ]; then
  echo "FAIL: Remote 'origin' points to '$REMOTE_URL' (expected: '$REMOTE_PATH')."
  exit 1
fi

# Check if clone fetched the commit
if [ ! -f "$REPO_DIR/hello.txt" ]; then
  echo "FAIL: hello.txt not found in working copy. Clone was not successful."
  exit 1
fi

echo "PASS: Remote repository cloned successfully!"
exit 0
