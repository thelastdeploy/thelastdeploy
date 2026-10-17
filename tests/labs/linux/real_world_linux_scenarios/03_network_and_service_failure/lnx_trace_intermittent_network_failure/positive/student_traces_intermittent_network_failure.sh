#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Traces Intermittent Network Drops
# Lab: lnx-trace-intermittent-network-failure
# ==============================================================================

# Step 1: Ensure net-failure directory exists
student_exec \
  --step-name "Ensure net-failure directory exists" \
  --cmd "mkdir -p ~/net-failure" \
  --expect-exit-code 0

# Step 2: Inspect network statistics and TCP socket limits
student_exec \
  --step-name "Inspect network statistics and TCP socket limits" \
  --cmd "sysctl net.core.somaxconn && head -n 10 /proc/net/netstat 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write network drop analysis marker
student_exec \
  --step-name "Write network drop analysis marker" \
  --cmd "echo 'INTERMITTENT_PACKET_DROPS_TRACED_AND_FIXED' > ~/net-failure/network_drop_analysis.txt" \
  --expect-exit-code 0

# Step 4: Verify drop analysis file content
student_exec \
  --step-name "Verify drop analysis file content" \
  --cmd "cat ~/net-failure/network_drop_analysis.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "INTERMITTENT_PACKET_DROPS_TRACED_AND_FIXED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Trace Intermittent Network Drops verified successfully."
