#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Git Ignore List
# Lab: git-configure-gitignore
# ==============================================================================

# Step 1: Ensure initial test state with git repo
student_exec \
  --step-name "Prepare repository" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && rm -f ~/git-challenge/.gitignore" \
  --expect-exit-code 0

# Step 2: Configure .gitignore with *.log rule
student_exec \
  --step-name "Add *.log pattern to .gitignore" \
  --cmd "echo '*.log' > ~/git-challenge/.gitignore" \
  --expect-exit-code 0

# Step 3: Verify git recognizes debug.log as ignored
student_exec \
  --step-name "Verify debug.log is ignored" \
  --cmd "git -C ~/git-challenge check-ignore -q debug.log" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: gitignore configured correctly to ignore log files."
