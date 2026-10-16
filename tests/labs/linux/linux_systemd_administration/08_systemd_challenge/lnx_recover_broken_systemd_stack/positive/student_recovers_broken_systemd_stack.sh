#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Broken systemd Service Stack
# Lab: lnx-recover-broken-systemd-stack
# ==============================================================================

# Step 1: Ensure systemd-challenge directory exists
student_exec \
  --step-name "Create systemd-challenge directory" \
  --cmd "mkdir -p ~/systemd-challenge" \
  --expect-exit-code 0

# Step 2: Create repaired db.service unit file
student_exec \
  --step-name "Create db.service unit file" \
  --cmd "cat << 'EOF' > ~/systemd-challenge/db.service
[Unit]
Description=Database Service

[Service]
Type=simple
ExecStart=/bin/echo DB Ready
EOF" \
  --expect-exit-code 0

# Step 3: Create repaired app.service unit file with dependency declarations
student_exec \
  --step-name "Create app.service unit file" \
  --cmd "cat << 'EOF' > ~/systemd-challenge/app.service
[Unit]
Description=Application Service
Requires=db.service
After=db.service

[Service]
ExecStart=/bin/echo App Ready
EOF" \
  --expect-exit-code 0

# Step 4: Verify app.service content
student_exec \
  --step-name "Verify app.service dependency declarations" \
  --cmd "cat ~/systemd-challenge/app.service" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Requires=db.service"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: systemd stack recovery capstone verified."
