#!/bin/bash
# validator.sh — git-history-and-recovery / 06-recover-lost-work / git-recover-deleted-history
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
CORRECT_FILE="$REPO_DIR/.correct-hash"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify experimental-restored branch exists
if ! git -C "$REPO_DIR" show-ref --verify refs/heads/experimental-restored &>/dev/null; then
  echo "FAIL: Branch 'experimental-restored' not found."
  exit 1
fi

# Read correct hash
CORRECT_HASH=$(tr -d '[:space:]' < "$CORRECT_FILE")

# Verify branch points to correct commit hash
BRANCH_HEAD=$(git -C "$REPO_DIR" rev-parse refs/heads/experimental-restored)
if [ "$BRANCH_HEAD" != "$CORRECT_HASH" ]; then
  echo "FAIL: Branch 'experimental-restored' points to '$BRANCH_HEAD' (expected: '$CORRECT_HASH')."
  exit 1
fi

# Verify restored files exist in the branch
if ! git -C "$REPO_DIR" cat-file -e "experimental-restored:experiment.txt" 2>/dev/null; then
  echo "FAIL: Branch 'experimental-restored' does not contain 'experiment.txt'."
  exit 1
fi

echo "PASS: Deleted branch successfully recovered and restored!"
exit 0
