#!/bin/bash
# validator.sh — git-branching / 04-merge-conflicts / git-complete-merge
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

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

# Verify no active merge state exists
if [ -f "$REPO_DIR/.git/MERGE_HEAD" ]; then
  echo "FAIL: Merge is still in progress. Please run 'git commit' to complete the merge."
  exit 1
fi

# Verify the latest commit is a merge commit (has 2 parents)
PARENT_COUNT=$(git -C "$REPO_DIR" log -1 --format="%P" | wc -w)
if [ "$PARENT_COUNT" -ne 2 ]; then
  echo "FAIL: The latest commit on $ACTIVE_BRANCH is not a merge commit (parents: $PARENT_COUNT, expected: 2)."
  exit 1
fi

echo "PASS: Merge commit completed successfully!"
exit 0
