#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Collects Volatile Process and Network Evidence
# Lab: lnx-collect-process-and-network-evidence
# ==============================================================================

# Step 1: Ensure evidence-test directory exists
student_exec \
  --step-name "Ensure evidence-test directory exists" \
  --cmd "mkdir -p ~/evidence-test" \
  --expect-exit-code 0

# Step 2: Inspect volatile network connections and process open handles
student_exec \
  --step-name "Inspect network sockets and processes" \
  --cmd "ss -anp | head -n 10 && lsof -P -n -i 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write process and network evidence marker
student_exec \
  --step-name "Write process and network evidence marker" \
  --cmd "echo 'PROC_NET_EVIDENCE_COLLECTED' > ~/evidence-test/proc_net_evidence.txt" \
  --expect-exit-code 0

# Step 4: Verify proc_net_evidence.txt content
student_exec \
  --step-name "Verify proc_net_evidence.txt content" \
  --cmd "cat ~/evidence-test/proc_net_evidence.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PROC_NET_EVIDENCE_COLLECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Volatile process and network evidence collection verified."
