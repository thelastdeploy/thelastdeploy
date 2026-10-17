#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Process Task Internals in /proc
# Lab: lnx-inspect-process-internals
# ==============================================================================

# Step 1: Ensure proc-internals-test directory exists
student_exec \
  --step-name "Ensure proc-internals-test directory exists" \
  --cmd "mkdir -p ~/proc-internals-test" \
  --expect-exit-code 0

# Step 2: Inspect process state in /proc
student_exec \
  --step-name "Inspect process status in /proc" \
  --cmd "cat /proc/self/status | head -n 10" \
  --expect-exit-code 0

# Step 3: Write process internals inspection marker
student_exec \
  --step-name "Write proc info marker" \
  --cmd "echo 'PROCESS_INTERNALS_INSPECTED' > ~/proc-internals-test/proc_info.txt" \
  --expect-exit-code 0

# Step 4: Verify content of proc_info.txt
student_exec \
  --step-name "Verify proc_info.txt content" \
  --cmd "cat ~/proc-internals-test/proc_info.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROCESS_INTERNALS_INSPECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Process task internals inspection verified."
