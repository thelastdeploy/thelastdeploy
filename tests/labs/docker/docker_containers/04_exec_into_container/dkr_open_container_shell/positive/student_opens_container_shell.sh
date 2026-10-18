#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Writes Hostname Inside Container
# Lab: dkr-open-container-shell
# ==============================================================================

# Step 1: Write container hostname into /tmp/touchme inside container
student_exec \
  --step-name "Write container hostname into /tmp/touchme inside container" \
  --cmd "docker exec interactive-shell-target sh -c 'hostname > /tmp/touchme'" \
  --expect-exit-code 0

# Step 2: Verify touchme file contents inside container
student_exec \
  --step-name "Verify touchme file contents inside container" \
  --cmd "docker exec interactive-shell-target cat /tmp/touchme" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Successfully wrote hostname inside container file."
