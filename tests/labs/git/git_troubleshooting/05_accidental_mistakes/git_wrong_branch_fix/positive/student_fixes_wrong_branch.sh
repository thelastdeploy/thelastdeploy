#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Commit on Wrong Branch
# Lab: git-wrong-branch-fix
# ==============================================================================

# Step 1: Prepare git repository with feature committed to main
student_exec \
  --step-name "Prepare repository with accidental commit on main" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'console.log(\"login\");' > ~/git-challenge/login.js && git -C ~/git-challenge add login.js && git -C ~/git-challenge commit -m 'Add login feature'" \
  --expect-exit-code 0

# Step 2: Branch feature-login and reset main
student_exec \
  --step-name "Branch feature-login and reset main" \
  --cmd "cd ~/git-challenge && git branch feature-login && git reset --hard HEAD~1" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Accidental commit moved to 'feature-login' and default branch reset successfully!"
