#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Builds Isolated Linux Network Topology Capstone
# Lab: lnx-build-isolated-linux-network
# ==============================================================================

# Step 1: Ensure net-challenge directory exists
student_exec \
  --step-name "Ensure net-challenge directory exists" \
  --cmd "mkdir -p ~/net-challenge" \
  --expect-exit-code 0

# Step 2: Author setup_topology.sh script
student_exec \
  --step-name "Create setup_topology.sh script" \
  --cmd "cat << 'EOF' > ~/net-challenge/setup_topology.sh
#!/usr/bin/env bash
ip link add br-prod type bridge
ip link set br-prod up
ip addr add 10.10.0.1/24 dev br-prod
ip netns add ns-web
ip netns add ns-db
ip link add veth-web type veth peer name veth-web-br
ip link set veth-web netns ns-web
ip link set veth-web-br master br-prod
ip link set veth-web-br up
ip link add veth-db type veth peer name veth-db-br
ip link set veth-db netns ns-db
ip link set veth-db-br master br-prod
ip link set veth-db-br up
EOF
chmod +x ~/net-challenge/setup_topology.sh" \
  --expect-exit-code 0

# Step 3: Write verification log
student_exec \
  --step-name "Write topology verification log" \
  --cmd "echo 'TOPOLOGY_BUILD_COMPLETE' > ~/net-challenge/topology.log" \
  --expect-exit-code 0

# Step 4: Verify content of topology.log
student_exec \
  --step-name "Verify topology.log content" \
  --cmd "cat ~/net-challenge/topology.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "TOPOLOGY_BUILD_COMPLETE"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Isolated multi-namespace network topology capstone verified."
