#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Preserves Volatile System State
# Lab: lnx-preserve-system-state
# ==============================================================================

# Step 1: Ensure ir-test directory exists
student_exec \
  --step-name "Ensure ir-test directory exists" \
  --cmd "mkdir -p ~/ir-test" \
  --expect-exit-code 0

# Step 2: Capture volatile system state
student_exec \
  --step-name "Capture volatile system state" \
  --cmd "ss -tulpn && ps auxf | head -n 15 && last -a | head -n 10" \
  --expect-exit-code 0

# Step 3: Write volatile state marker
student_exec \
  --step-name "Write volatile state marker" \
  --cmd "echo 'VOLATILE_SYSTEM_STATE_PRESERVED' > ~/ir-test/volatile_state.txt" \
  --expect-exit-code 0

# Step 4: Verify volatile_state.txt content
student_exec \
  --step-name "Verify volatile_state.txt content" \
  --cmd "cat ~/ir-test/volatile_state.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VOLATILE_SYSTEM_STATE_PRESERVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Volatile system state preservation verified."
