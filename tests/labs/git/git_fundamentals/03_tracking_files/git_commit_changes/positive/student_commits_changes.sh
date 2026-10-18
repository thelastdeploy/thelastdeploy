#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Commits Staged Changes
# Lab: git-commit-changes
# ==============================================================================

# Step 1: Ensure initial test state with staged file
student_exec \
  --step-name "Prepare repository with staged file" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git config -f ~/git-challenge/.git/config user.email 'student@thelastdeploy.com' && git config -f ~/git-challenge/.git/config user.name 'DevOps Student' && echo '# My Project' > ~/git-challenge/README.md && git -C ~/git-challenge add README.md" \
  --expect-exit-code 0

# Step 2: Commit staged changes
student_exec \
  --step-name "Commit staged changes" \
  --cmd "cd ~/git-challenge && git commit -m 'Add README file'" \
  --expect-exit-code 0

# Step 3: Verify clean working tree
student_exec \
  --step-name "Verify clean git status" \
  --cmd "git -C ~/git-challenge status --porcelain" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Staged changes committed successfully."
