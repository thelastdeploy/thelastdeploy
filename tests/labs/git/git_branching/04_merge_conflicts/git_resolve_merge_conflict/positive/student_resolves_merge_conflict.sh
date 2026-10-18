#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Resolves Merge Conflict
# Lab: git-resolve-merge-conflict
# ==============================================================================

# Step 1: Prepare initial conflict state
student_exec \
  --step-name "Prepare conflict state" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo '<h1>Default Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Initial index' && git -C ~/git-challenge checkout -b feature-conflict && echo '<h1>Feature Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Edit on feature' && git -C ~/git-challenge checkout main && echo '<h1>Main Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Edit on main' && (git -C ~/git-challenge merge feature-conflict || true)" \
  --expect-exit-code 0

# Step 2: Resolve conflict in index.html
student_exec \
  --step-name "Resolve conflict by removing conflict markers" \
  --cmd "echo '<h1>Merged Site</h1>' > ~/git-challenge/index.html" \
  --expect-exit-code 0

# Step 3: Stage the resolved file
student_exec \
  --step-name "Stage resolved index.html" \
  --cmd "cd ~/git-challenge && git add index.html" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Merge conflict in index.html resolved and staged successfully!"
