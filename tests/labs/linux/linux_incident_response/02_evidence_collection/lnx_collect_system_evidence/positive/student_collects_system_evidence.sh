#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Collects System File & Environment Evidence
# Lab: lnx-collect-system-evidence
# ==============================================================================

# Step 1: Ensure evidence-test directory exists
student_exec \
  --step-name "Ensure evidence-test directory exists" \
  --cmd "mkdir -p ~/evidence-test" \
  --expect-exit-code 0

# Step 2: Inspect environment variables and security credentials
student_exec \
  --step-name "Inspect environment and credentials" \
  --cmd "cat /proc/self/environ | tr '\0' '\n' | head -n 10 && ls -la ~/.ssh/ 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write system evidence marker
student_exec \
  --step-name "Write system evidence marker" \
  --cmd "echo 'SYSTEM_EVIDENCE_COLLECTED' > ~/evidence-test/system_evidence.txt" \
  --expect-exit-code 0

# Step 4: Verify system_evidence.txt content
student_exec \
  --step-name "Verify system_evidence.txt content" \
  --cmd "cat ~/evidence-test/system_evidence.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SYSTEM_EVIDENCE_COLLECTED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: System file and environment evidence collection verified."
