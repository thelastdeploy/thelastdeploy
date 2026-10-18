#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Reverts Multiple Commits
# Lab: git-revert-multiple-commits
# ==============================================================================

# Step 1: Prepare git repository with four sequential commits
student_exec \
  --step-name "Prepare repository with four commits" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo '1' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo '2' > ~/git-challenge/two.txt && git -C ~/git-challenge add two.txt && git -C ~/git-challenge commit -m 'Second commit' && echo '3' > ~/git-challenge/three.txt && git -C ~/git-challenge add three.txt && git -C ~/git-challenge commit -m 'Third commit' && echo '4' > ~/git-challenge/four.txt && git -C ~/git-challenge add four.txt && git -C ~/git-challenge commit -m 'Fourth commit'" \
  --expect-exit-code 0

# Step 2: Revert the last two commits with --no-commit and commit with specific message
student_exec \
  --step-name "Revert last two commits and create custom revert commit" \
  --cmd "cd ~/git-challenge && git revert --no-commit HEAD HEAD~1 && git commit -m 'Revert last two features'" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully reverted multiple commits in a single custom commit!"
