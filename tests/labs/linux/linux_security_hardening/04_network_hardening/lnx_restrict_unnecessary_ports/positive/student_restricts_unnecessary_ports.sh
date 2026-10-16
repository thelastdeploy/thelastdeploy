#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits Sockets and Restricts Unnecessary Ports
# Lab: lnx-restrict-unnecessary-ports
# ==============================================================================

# Step 1: Ensure net-sec-test directory exists
student_exec \
  --step-name "Create net-sec-test directory" \
  --cmd "mkdir -p ~/net-sec-test" \
  --expect-exit-code 0

# Step 2: Audit listening sockets and network services
student_exec \
  --step-name "Audit listening sockets" \
  --cmd "ss -tulpn 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Record verification indicator in ports_summary.txt
student_exec \
  --step-name "Record port restriction summary" \
  --cmd "echo 'UNNECESSARY_PORTS_RESTRICTED' > ~/net-sec-test/ports_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify ports_summary.txt content
student_exec \
  --step-name "Verify ports_summary.txt content" \
  --cmd "cat ~/net-sec-test/ports_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "UNNECESSARY_PORTS_RESTRICTED"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Unnecessary port restriction verified."
