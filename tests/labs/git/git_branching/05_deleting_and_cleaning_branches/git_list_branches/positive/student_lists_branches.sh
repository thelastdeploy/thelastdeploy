#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Lists Branches
# Lab: git-list-branches
# ==============================================================================

# Step 1: Prepare repository state with multiple branches
student_exec \
  --step-name "Prepare repository with multiple branches" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'initial' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge branch feature-login && git -C ~/git-challenge branch feature-payment && git -C ~/git-challenge branch bugfix-header && rm -f ~/git-challenge/branches.txt" \
  --expect-exit-code 0

# Step 2: List branches and save to branches.txt
student_exec \
  --step-name "List branches to branches.txt" \
  --cmd "cd ~/git-challenge && git branch > branches.txt" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Branch list saved and verified successfully!"
