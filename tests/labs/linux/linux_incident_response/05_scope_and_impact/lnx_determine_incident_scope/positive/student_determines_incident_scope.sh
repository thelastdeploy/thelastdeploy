#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Determines Incident Scope and Lateral Movement
# Lab: lnx-determine-incident-scope
# ==============================================================================

# Step 1: Ensure scope-test directory exists
student_exec \
  --step-name "Ensure scope-test directory exists" \
  --cmd "mkdir -p ~/scope-test" \
  --expect-exit-code 0

# Step 2: Check active outbound sockets and shell histories
student_exec \
  --step-name "Check active outbound sockets and shell histories" \
  --cmd "ss -tun 2>/dev/null | head -n 10 || true && cat ~/.bash_history 2>/dev/null | tail -n 10 || true" \
  --expect-exit-code 0

# Step 3: Write incident scope marker
student_exec \
  --step-name "Write incident scope marker" \
  --cmd "echo 'INCIDENT_SCOPE_DETERMINED' > ~/scope-test/incident_scope.txt" \
  --expect-exit-code 0

# Step 4: Verify incident_scope.txt content
student_exec \
  --step-name "Verify incident_scope.txt content" \
  --cmd "cat ~/scope-test/incident_scope.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INCIDENT_SCOPE_DETERMINED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Incident scope and lateral movement assessment verified."
