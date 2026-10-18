#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates a Branch
# Lab: git-create-branch
# ==============================================================================

# Step 1: Ensure initial test state with git repo
student_exec \
  --step-name "Prepare repository with initial commit" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit'" \
  --expect-exit-code 0

# Step 2: Create feature-login branch
student_exec \
  --step-name "Create feature-login branch" \
  --cmd "cd ~/git-challenge && git branch feature-login" \
  --expect-exit-code 0

# Step 3: Verify branch exists
student_exec \
  --step-name "Verify feature-login branch ref" \
  --cmd "git -C ~/git-challenge show-ref --verify refs/heads/feature-login" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Branch 'feature-login' created successfully!"
