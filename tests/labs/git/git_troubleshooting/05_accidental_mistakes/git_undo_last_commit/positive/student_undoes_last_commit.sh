#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Undoes the Last Commit
# Lab: git-undo-last-commit
# ==============================================================================

# Step 1: Prepare git repository with three sequential commits
student_exec \
  --step-name "Prepare repository with three commits" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo '1' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo '2' > ~/git-challenge/two.txt && git -C ~/git-challenge add two.txt && git -C ~/git-challenge commit -m 'Second commit' && echo '3' > ~/git-challenge/three.txt && git -C ~/git-challenge add three.txt && git -C ~/git-challenge commit -m 'Third commit'" \
  --expect-exit-code 0

# Step 2: Undo the last commit with soft reset
student_exec \
  --step-name "Execute git reset --soft HEAD~1" \
  --cmd "cd ~/git-challenge && git reset --soft HEAD~1" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Last commit undone and changes kept in staging index!"
