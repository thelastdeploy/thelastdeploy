#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Repository Log
# Lab: git-inspect-history
# ==============================================================================

# Step 1: Ensure initial test state with committed repo
student_exec \
  --step-name "Prepare repository with initial commit" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git config -f ~/git-challenge/.git/config user.email 'student@thelastdeploy.com' && git config -f ~/git-challenge/.git/config user.name 'DevOps Student' && echo '# My Project' > ~/git-challenge/README.md && git -C ~/git-challenge add README.md && git -C ~/git-challenge commit -m 'Initial commit' && rm -f ~/git-challenge/latest_commit.txt" \
  --expect-exit-code 0

# Step 2: Extract HEAD commit hash to target file
student_exec \
  --step-name "Extract latest commit hash to file" \
  --cmd "git -C ~/git-challenge rev-parse HEAD > ~/git-challenge/latest_commit.txt" \
  --expect-exit-code 0

# Step 3: Verify target file is non-empty
student_exec \
  --step-name "Verify latest_commit.txt is non-empty" \
  --cmd "test -s ~/git-challenge/latest_commit.txt" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Latest commit hash successfully identified."
