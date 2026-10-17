#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Connects Network Namespaces with veth Pairs
# Lab: lnx-connect-network-namespaces
# ==============================================================================

# Step 1: Ensure netns-test directory exists
student_exec \
  --step-name "Ensure netns-test directory exists" \
  --cmd "mkdir -p ~/netns-test" \
  --expect-exit-code 0

# Step 2: Write veth connection script
student_exec \
  --step-name "Create connect_ns.sh script" \
  --cmd "cat << 'EOF' > ~/netns-test/connect_ns.sh
#!/usr/bin/env bash
ip netns add ns-demo
ip link add veth-h type veth peer name veth-n
ip link set veth-n netns ns-demo
EOF
chmod +x ~/netns-test/connect_ns.sh" \
  --expect-exit-code 0

# Step 3: Write summary log line
student_exec \
  --step-name "Write veth connection summary" \
  --cmd "echo 'VETH_PAIR_CONFIGURED' > ~/netns-test/veth_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of veth_summary.txt
student_exec \
  --step-name "Verify veth_summary.txt content" \
  --cmd "cat ~/netns-test/veth_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "VETH_PAIR_CONFIGURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: veth pair network namespace connection verified."
