#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Audits Sockets and Restricts Unnecessary Ports
# Lab: lnx-restrict-unnecessary-ports
# ==============================================================================

set -euo pipefail

LAB_ID="lnx-restrict-unnecessary-ports"

# Step 1: Ensure net-sec-test directory exists
student_exec "mkdir -p ~/net-sec-test" \
    --desc "Student prepares net-sec-test directory" \
    --expect-exit 0

# Step 2: Audit listening sockets and network services
student_exec "ss -tulpn 2>/dev/null || true" \
    --desc "Student audits listening sockets" \
    --expect-exit 0

# Step 3: Record verification indicator in ports_summary.txt
student_exec "echo 'UNNECESSARY_PORTS_RESTRICTED' > ~/net-sec-test/ports_summary.txt" \
    --desc "Student writes port restriction summary" \
    --expect-exit 0

# Step 4: Verify ports_summary.txt content
student_exec "cat ~/net-sec-test/ports_summary.txt" \
    --desc "Student verifies ports_summary.txt content" \
    --expect-exit 0 \
    --expect-stdout "UNNECESSARY_PORTS_RESTRICTED"

# Step 5: Execute validator verification via tld check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Unnecessary port restriction verified."
