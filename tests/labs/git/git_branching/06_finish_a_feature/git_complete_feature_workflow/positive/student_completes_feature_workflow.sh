#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Completes Feature Workflow
# Lab: git-complete-feature-workflow
# ==============================================================================

# Step 1: Prepare initial repository on main
student_exec \
  --step-name "Prepare repository with initial commit" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit'" \
  --expect-exit-code 0

# Step 2: Create and switch to auth-feature branch
student_exec \
  --step-name "Create and switch to auth-feature branch" \
  --cmd "cd ~/git-challenge && git switch -c auth-feature" \
  --expect-exit-code 0

# Step 3: Create, stage and commit auth.js
student_exec \
  --step-name "Create and commit auth.js" \
  --cmd "cd ~/git-challenge && echo 'console.log(\"auth\");' > auth.js && git add auth.js && git commit -m 'Implement auth feature'" \
  --expect-exit-code 0

# Step 4: Switch back to main branch
student_exec \
  --step-name "Switch back to main branch" \
  --cmd "cd ~/git-challenge && git switch main" \
  --expect-exit-code 0

# Step 5: Merge auth-feature into main
student_exec \
  --step-name "Merge auth-feature into main" \
  --cmd "cd ~/git-challenge && git merge auth-feature" \
  --expect-exit-code 0

# Step 6: Delete merged auth-feature branch
student_exec \
  --step-name "Delete merged auth-feature branch" \
  --cmd "cd ~/git-challenge && git branch -d auth-feature" \
  --expect-exit-code 0

# Step 7: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Complete feature branch workflow executed successfully!"
