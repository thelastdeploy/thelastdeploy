#!/bin/bash
# validator.sh — git-history-and-recovery / 02-checkout-and-detached-head / git-return-to-main
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify HEAD is NOT detached
if ! git -C "$REPO_DIR" symbolic-ref -q HEAD &>/dev/null; then
  echo "FAIL: HEAD is still detached. You need to checkout/switch back to your main or master branch."
  exit 1
fi

# Verify active branch is main or master
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "main" ] && [ "$ACTIVE_BRANCH" != "master" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master')."
  exit 1
fi

echo "PASS: Returned to the default branch successfully!"
exit 0
