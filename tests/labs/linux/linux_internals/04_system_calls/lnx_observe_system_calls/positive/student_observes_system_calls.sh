#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Observes System Call Boundary
# Lab: lnx-observe-system-calls
# ==============================================================================

# Step 1: Ensure syscall-test directory exists
student_exec \
  --step-name "Ensure syscall-test directory exists" \
  --cmd "mkdir -p ~/syscall-test" \
  --expect-exit-code 0

# Step 2: Query kernel version
student_exec \
  --step-name "Query kernel architecture" \
  --cmd "uname -a" \
  --expect-exit-code 0

# Step 3: Write system call boundary observation marker
student_exec \
  --step-name "Write syscall basics marker" \
  --cmd "echo 'SYSTEM_CALL_BOUNDARY_OBSERVED' > ~/syscall-test/syscall_basics.txt" \
  --expect-exit-code 0

# Step 4: Verify content of syscall_basics.txt
student_exec \
  --step-name "Verify syscall_basics.txt content" \
  --cmd "cat ~/syscall-test/syscall_basics.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_CALL_BOUNDARY_OBSERVED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System call boundary observation verified."
