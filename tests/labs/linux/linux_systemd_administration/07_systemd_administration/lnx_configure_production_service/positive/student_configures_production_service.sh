#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures Hardened Production systemd Service
# Lab: lnx-configure-production-service
# ==============================================================================

# Step 1: Ensure prod-service-test directory exists
student_exec \
  --step-name "Create prod-service-test directory" \
  --cmd "mkdir -p ~/prod-service-test" \
  --expect-exit-code 0

# Step 2: Create prod-api.service unit file with production configuration
student_exec \
  --step-name "Create production service unit" \
  --cmd "cat << 'EOF' > ~/prod-service-test/prod-api.service
[Unit]
Description=Production API Gateway
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=/etc/default/prod-api
ExecStart=/usr/bin/echo Starting Prod API
Restart=always
LimitNOFILE=65536
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF" \
  --expect-exit-code 0

# Step 3: Verify unit file content
student_exec \
  --step-name "Verify unit file content" \
  --cmd "cat ~/prod-service-test/prod-api.service" \
  --expect-exit-code 0 \
  --expect-stdout-contains "LimitNOFILE=65536"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Production systemd service hardening verified."
