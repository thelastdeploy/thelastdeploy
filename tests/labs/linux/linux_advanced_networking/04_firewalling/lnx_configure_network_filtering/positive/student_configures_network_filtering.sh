#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Network Traffic Filtering
# Lab: lnx-configure-network-filtering
# ==============================================================================

# Step 1: Ensure fw-test directory exists
student_exec \
  --step-name "Ensure fw-test directory exists" \
  --cmd "mkdir -p ~/fw-test" \
  --expect-exit-code 0

# Step 2: Write firewall filtering configuration script
student_exec \
  --step-name "Create filter_rules.sh script" \
  --cmd "cat << 'EOF' > ~/fw-test/filter_rules.sh
#!/usr/bin/env bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
EOF
chmod +x ~/fw-test/filter_rules.sh" \
  --expect-exit-code 0

# Step 3: Write filtering summary log
student_exec \
  --step-name "Write filtering summary log" \
  --cmd "echo 'FILTERING_RULES_CONFIGURED' > ~/fw-test/filter_summary.txt" \
  --expect-exit-code 0

# Step 4: Verify content of filter_summary.txt
student_exec \
  --step-name "Verify filter_summary.txt content" \
  --cmd "cat ~/fw-test/filter_summary.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "FILTERING_RULES_CONFIGURED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Network traffic filtering configuration verified."
