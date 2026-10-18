#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Reverts a Bad Commit
# Lab: git-revert-bad-commit
# ==============================================================================

# Step 1: Prepare git repository with three commits, the last adding api_key
student_exec \
  --step-name "Prepare repository with bad commit" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'port=8080' > ~/git-challenge/app.config && git -C ~/git-challenge add app.config && git -C ~/git-challenge commit -m 'Initial commit' && echo 'db_logging=true' >> ~/git-challenge/app.config && git -C ~/git-challenge add app.config && git -C ~/git-challenge commit -m 'Add database logging config' && echo 'api_key=SECRET_XYZ' >> ~/git-challenge/app.config && git -C ~/git-challenge add app.config && git -C ~/git-challenge commit -m 'Add API key config'" \
  --expect-exit-code 0

# Step 2: Revert the bad commit
student_exec \
  --step-name "Revert latest commit" \
  --cmd "cd ~/git-challenge && git revert HEAD --no-edit" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Bad commit reverted successfully!"
