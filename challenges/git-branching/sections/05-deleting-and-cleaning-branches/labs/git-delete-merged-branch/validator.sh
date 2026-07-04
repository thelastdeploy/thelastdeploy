#!/bin/bash
# validator.sh — git-branching / 05-deleting-and-cleaning-branches / git-delete-merged-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify branch feature-old does NOT exist
if git -C "$REPO_DIR" show-ref --verify refs/heads/feature-old &>/dev/null; then
  echo "FAIL: Branch 'feature-old' still exists. Did you delete it?"
  exit 1
fi

# Verify branch feature-active STILL exists
if ! git -C "$REPO_DIR" show-ref --verify refs/heads/feature-active &>/dev/null; then
  echo "FAIL: Branch 'feature-active' was deleted, but only the merged branch 'feature-old' should be deleted."
  exit 1
fi

echo "PASS: Merged branch 'feature-old' deleted successfully!"
exit 0
