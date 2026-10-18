#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Removes Sensitive File from History
# Lab: git-remove-sensitive-file
# ==============================================================================

# Step 1: Prepare git repository with accidentally committed password.txt
student_exec \
  --step-name "Prepare repository with committed password file" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/one.txt && git -C ~/git-challenge add one.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'my_secret_key' > ~/git-challenge/password.txt && git -C ~/git-challenge add password.txt && git -C ~/git-challenge commit -m 'Add password file'" \
  --expect-exit-code 0

# Step 2: Untrack, ignore, and amend commit
student_exec \
  --step-name "Untrack password.txt, ignore it, and amend commit" \
  --cmd "cd ~/git-challenge && git rm --cached password.txt && echo 'password.txt' >> .gitignore && git add .gitignore && git commit --amend --no-edit" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Sensitive file removed from commit history and ignored successfully!"
