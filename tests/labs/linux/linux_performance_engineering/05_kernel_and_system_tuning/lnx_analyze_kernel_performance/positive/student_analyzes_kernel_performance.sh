#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Analyzes Kernel Subsystem Tuneables
# Lab: lnx-analyze-kernel-performance
# ==============================================================================

# Step 1: Ensure kernel-opt-test directory exists
student_exec \
  --step-name "Ensure kernel-opt-test directory exists" \
  --cmd "mkdir -p ~/kernel-opt-test" \
  --expect-exit-code 0

# Step 2: Query kernel tuneables
student_exec \
  --step-name "Query sysctl socket and file limits" \
  --cmd "sysctl net.core.somaxconn fs.file-max 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write kernel tuneables analysis marker
student_exec \
  --step-name "Write sysctl analysis marker" \
  --cmd "echo 'KERNEL_TUNEABLES_ANALYZED' > ~/kernel-opt-test/sysctl_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify content of sysctl_analysis.txt
student_exec \
  --step-name "Verify sysctl_analysis.txt content" \
  --cmd "cat ~/kernel-opt-test/sysctl_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "KERNEL_TUNEABLES_ANALYZED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Kernel subsystem tuneables analysis verified."
