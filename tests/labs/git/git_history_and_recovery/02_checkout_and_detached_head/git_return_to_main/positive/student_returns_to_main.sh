#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Returns to Main Branch
# Lab: git-return-to-main
# ==============================================================================

# Step 1: Prepare git repository with detached HEAD
student_exec \
  --step-name "Prepare repository with detached HEAD" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'first' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'second' > ~/git-challenge/two.txt && git -C ~/git-challenge add two.txt && git -C ~/git-challenge commit -m 'Second commit' && echo 'third' > ~/git-challenge/three.txt && git -C ~/git-challenge add three.txt && git -C ~/git-challenge commit -m 'Third commit' && git -C ~/git-challenge checkout HEAD~2" \
  --expect-exit-code 0

# Step 2: Switch back to main branch
student_exec \
  --step-name "Switch back to main branch" \
  --cmd "cd ~/git-challenge && git switch main" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Returned to the default branch successfully!"
