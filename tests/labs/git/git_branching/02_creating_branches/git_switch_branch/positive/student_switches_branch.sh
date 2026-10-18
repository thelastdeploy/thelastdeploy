#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Switches to a Branch
# Lab: git-switch-branch
# ==============================================================================

# Step 1: Ensure initial test state with feature-login branch on main
student_exec \
  --step-name "Prepare repository with feature-login branch" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge branch feature-login" \
  --expect-exit-code 0

# Step 2: Switch to feature-login branch
student_exec \
  --step-name "Switch to feature-login branch" \
  --cmd "cd ~/git-challenge && git switch feature-login" \
  --expect-exit-code 0

# Step 3: Verify current active branch is feature-login
student_exec \
  --step-name "Verify active branch" \
  --cmd "git -C ~/git-challenge branch --show-current" \
  --expect-exit-code 0 \
  --expect-stdout-contains "feature-login"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully switched to branch 'feature-login'!"
