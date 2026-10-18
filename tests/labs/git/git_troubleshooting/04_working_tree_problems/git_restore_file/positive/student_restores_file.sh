#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Restores a Tracked File
# Lab: git-restore-file
# ==============================================================================

# Step 1: Prepare git repository with broken changes in tracked file
student_exec \
  --step-name "Prepare repository with modified tracked file" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'console.log(\"stable code\");' > ~/git-challenge/app.js && git -C ~/git-challenge add app.js && git -C ~/git-challenge commit -m 'Add app.js' && echo 'console.log(\"broken code\");' > ~/git-challenge/app.js" \
  --expect-exit-code 0

# Step 2: Restore file to committed state
student_exec \
  --step-name "Execute git restore app.js" \
  --cmd "cd ~/git-challenge && git restore app.js" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Tracked file restored successfully to stable commit!"
