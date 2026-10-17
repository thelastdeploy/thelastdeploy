#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Linux Network Bridge
# Lab: lnx-build-linux-network-bridge
# ==============================================================================

# Step 1: Ensure vnet-test directory exists
student_exec \
  --step-name "Ensure vnet-test directory exists" \
  --cmd "mkdir -p ~/vnet-test" \
  --expect-exit-code 0

# Step 2: Create bridge setup script
student_exec \
  --step-name "Create bridge_setup.sh script" \
  --cmd "cat << 'EOF' > ~/vnet-test/bridge_setup.sh
#!/usr/bin/env bash
ip link add br-test type bridge
ip link set br-test up
EOF
chmod +x ~/vnet-test/bridge_setup.sh" \
  --expect-exit-code 0

# Step 3: Write summary log line
student_exec \
  --step-name "Write bridge summary log" \
  --cmd "echo 'BRIDGE_CREATED: br-test' > ~/vnet-test/bridge_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of bridge_summary.txt
student_exec \
  --step-name "Verify bridge_summary.txt content" \
  --cmd "cat ~/vnet-test/bridge_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "BRIDGE_CREATED: br-test"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Linux network bridge setup verified."
