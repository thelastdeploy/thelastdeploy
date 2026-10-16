#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Controls Service Boot Startup State
# Lab: lnx-control-service-startup
# ==============================================================================

# Step 1: Ensure service-test directory exists
student_exec \
  --step-name "Create service-test directory" \
  --cmd "mkdir -p ~/service-test" \
  --expect-exit-code 0

# Step 2: Query service enablement and write to boot_state.txt
student_exec \
  --step-name "Check service boot state" \
  --cmd "STATE=\$(systemctl is-enabled systemd-journald.service 2>/dev/null || systemctl is-enabled cron.service 2>/dev/null || echo 'static')
echo \"ENABLE_STATE: \$STATE\" > ~/service-test/boot_state.txt" \
  --expect-exit-code 0

# Step 3: Verify boot_state.txt content
student_exec \
  --step-name "Verify boot_state.txt content" \
  --cmd "cat ~/service-test/boot_state.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ENABLE_STATE: "

# Step 4: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Service boot startup state verified."
