#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Removes Container
# Lab: dkr-remove-container
# ==============================================================================

# Step 1: Remove old-trash-container
student_exec \
  --step-name "Remove container old-trash-container" \
  --cmd "docker rm -f old-trash-container 2>/dev/null || true" \
  --expect-exit-code 0

# Step 2: Verify old-trash-container is not present
student_exec \
  --step-name "Verify container is removed" \
  --cmd "docker ps -a --filter name=old-trash-container --format '{{.Names}}'" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Stopped container removed successfully."
