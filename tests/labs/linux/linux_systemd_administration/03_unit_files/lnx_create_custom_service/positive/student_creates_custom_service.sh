#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates Custom systemd Service Unit File
# Lab: lnx-create-custom-service
# ==============================================================================

# Step 1: Ensure unit-test directory exists
student_exec \
  --step-name "Create unit-test directory" \
  --cmd "mkdir -p ~/unit-test" \
  --expect-exit-code 0

# Step 2: Create custom-app.service unit file with required sections
student_exec \
  --step-name "Create custom service unit file" \
  --cmd "cat << 'EOF' > ~/unit-test/custom-app.service
[Unit]
Description=Custom App

[Service]
Type=simple
ExecStart=/usr/bin/echo Hello
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF" \
  --expect-exit-code 0

# Step 3: Verify custom service file content
student_exec \
  --step-name "Verify unit file content" \
  --cmd "cat ~/unit-test/custom-app.service" \
  --expect-exit-code 0 \
  --expect-stdout-contains "[Service]"

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Custom unit file structure verified."
