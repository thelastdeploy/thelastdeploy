#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Application System Calls with strace
# Lab: lnx-trace-application-system-calls
# ==============================================================================

# Step 1: Ensure syscall-test directory exists
student_exec \
  --step-name "Ensure syscall-test directory exists" \
  --cmd "mkdir -p ~/syscall-test" \
  --expect-exit-code 0

# Step 2: Trace system calls via strace
student_exec \
  --step-name "Run strace summary on ls" \
  --cmd "strace -c ls / >/dev/null 2>&1 || true" \
  --expect-exit-code 0

# Step 3: Write strace summary verified marker
student_exec \
  --step-name "Write strace summary marker" \
  --cmd "echo 'STRACE_SUMMARY_VERIFIED' > ~/syscall-test/strace_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of strace_summary.txt
student_exec \
  --step-name "Verify strace_summary.txt content" \
  --cmd "cat ~/syscall-test/strace_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "STRACE_SUMMARY_VERIFIED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Application system call tracing verified."
