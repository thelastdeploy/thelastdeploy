#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Edits Mounted File
# Lab: dkr-edit-mounted-file
# ==============================================================================

# Step 1: Update notes.txt on host machine
student_exec \
  --step-name "Update notes.txt on host machine" \
  --cmd "echo 'DevLab Rocks' > ~/docker-mount-test/notes.txt" \
  --expect-exit-code 0

# Step 2: Verify file contents inside container
student_exec \
  --step-name "Verify file contents inside container" \
  --cmd "docker exec notes-viewer cat /notes/notes.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "DevLab Rocks"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully verified bind-mounted file edits."
