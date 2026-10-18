#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Initializes Git Repository
# Lab: git-create-repository
# ==============================================================================

# Step 1: Ensure directory exists
student_exec \
  --step-name "Ensure target directory exists" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge" \
  --expect-exit-code 0

# Step 2: Initialize git repository
student_exec \
  --step-name "Initialize git repository" \
  --cmd "cd ~/git-challenge && git init" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Initialized empty Git repository"

# Step 3: Verify .git directory exists
student_exec \
  --step-name "Verify .git directory" \
  --cmd "test -d ~/git-challenge/.git" \
  --expect-exit-code 0

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Git repository initialized successfully in"
