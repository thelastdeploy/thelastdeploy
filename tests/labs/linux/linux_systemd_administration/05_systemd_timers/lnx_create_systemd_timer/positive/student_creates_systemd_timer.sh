#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Creates systemd Service and Timer Unit Pair
# Lab: lnx-create-systemd-timer
# ==============================================================================

# Step 1: Ensure timer-test directory exists
student_exec \
  --step-name "Create timer-test directory" \
  --cmd "mkdir -p ~/timer-test" \
  --expect-exit-code 0

# Step 2: Create companion service unit file
student_exec \
  --step-name "Create maint.service unit" \
  --cmd "cat << 'EOF' > ~/timer-test/maint.service
[Unit]
Description=Maintenance Service

[Service]
Type=oneshot
ExecStart=/bin/echo Maint
EOF" \
  --expect-exit-code 0

# Step 3: Create timer unit file
student_exec \
  --step-name "Create maint.timer unit" \
  --cmd "cat << 'EOF' > ~/timer-test/maint.timer
[Unit]
Description=Maintenance Timer

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF" \
  --expect-exit-code 0

# Step 4: Verify timer unit content
student_exec \
  --step-name "Verify timer unit content" \
  --cmd "cat ~/timer-test/maint.timer" \
  --expect-exit-code 0 \
  --expect-stdout-contains "OnCalendar=daily"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: systemd timer unit creation verified."
