#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Saves Project State
# Lab: git-save-project-state
# ==============================================================================

# Step 1: Ensure initial test state
student_exec \
  --step-name "Prepare fresh workspace" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge" \
  --expect-exit-code 0

# Step 2: Initialize git repository and configure user
student_exec \
  --step-name "Initialize repository and configure user" \
  --cmd "cd ~/git-challenge && git init -b main && git config user.email 'student@thelastdeploy.com' && git config user.name 'DevOps Student'" \
  --expect-exit-code 0

# Step 3: Create .gitignore and index.html
student_exec \
  --step-name "Create project files and ignore rules" \
  --cmd "echo '*.tmp' > ~/git-challenge/.gitignore && echo '<h1>My Project</h1>' > ~/git-challenge/index.html" \
  --expect-exit-code 0

# Step 4: Stage and commit project files
student_exec \
  --step-name "Stage and commit project files" \
  --cmd "cd ~/git-challenge && git add .gitignore index.html && git commit -m 'Initial commit with project files'" \
  --expect-exit-code 0

# Step 5: Verify clean repository status
student_exec \
  --step-name "Verify clean repository status" \
  --cmd "git -C ~/git-challenge status --porcelain" \
  --expect-exit-code 0

# Step 6: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Repository initialized, .gitignore configured, index.html added and committed successfully."
