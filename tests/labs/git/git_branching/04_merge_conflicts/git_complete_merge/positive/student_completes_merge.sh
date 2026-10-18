#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Completes the Merge Commit
# Lab: git-complete-merge
# ==============================================================================

# Step 1: Prepare staged merge state
student_exec \
  --step-name "Prepare staged conflict resolution" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo '<h1>Default Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Initial index' && git -C ~/git-challenge checkout -b feature-conflict && echo '<h1>Feature Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Edit on feature' && git -C ~/git-challenge checkout main && echo '<h1>Main Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Edit on main' && (git -C ~/git-challenge merge feature-conflict || true) && echo '<h1>Resolved Site</h1>' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html" \
  --expect-exit-code 0

# Step 2: Complete the merge commit
student_exec \
  --step-name "Complete the merge commit" \
  --cmd "cd ~/git-challenge && git commit -m 'Merge branch feature-conflict into main'" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Merge commit completed successfully!"
