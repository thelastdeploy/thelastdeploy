#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Checks Out an Old Commit
# Lab: git-checkout-old-commit
# ==============================================================================

# Step 1: Prepare git repository with three sequential commits
student_exec \
  --step-name "Prepare repository with three commits" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'first' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'second' > ~/git-challenge/two.txt && git -C ~/git-challenge add two.txt && git -C ~/git-challenge commit -m 'Second commit' && echo 'third' > ~/git-challenge/three.txt && git -C ~/git-challenge add three.txt && git -C ~/git-challenge commit -m 'Third commit'" \
  --expect-exit-code 0

# Step 2: Checkout the second commit (main~1) to enter detached HEAD
student_exec \
  --step-name "Checkout second commit into detached HEAD" \
  --cmd "cd ~/git-challenge && git checkout main~1" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully checked out the second commit and entered detached HEAD state!"
