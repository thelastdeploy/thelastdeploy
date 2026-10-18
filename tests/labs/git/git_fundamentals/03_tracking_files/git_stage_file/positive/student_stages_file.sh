#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Stages a Modified File
# Lab: git-stage-file
# ==============================================================================

# Step 1: Ensure initial test state with git repo and unstaged file
student_exec \
  --step-name "Prepare repository with unstaged file" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && echo '# My Project' > ~/git-challenge/README.md" \
  --expect-exit-code 0

# Step 2: Stage README.md
student_exec \
  --step-name "Stage README.md file" \
  --cmd "cd ~/git-challenge && git add README.md" \
  --expect-exit-code 0

# Step 3: Verify file is staged in git index
student_exec \
  --step-name "Verify staged status" \
  --cmd "git -C ~/git-challenge diff --name-only --cached" \
  --expect-exit-code 0 \
  --expect-stdout-contains "README.md"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: README.md staged successfully."
