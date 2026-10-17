#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Automates Linux Operations
# Lab: lnx-automate-linux-operations
# ==============================================================================

# Step 1: Ensure mastery-auto directory exists
student_exec \
  --step-name "Ensure mastery-auto directory exists" \
  --cmd "mkdir -p ~/mastery-auto" \
  --expect-exit-code 0

# Step 2: Audit systemd timer units and cron
student_exec \
  --step-name "Audit systemd timer units and cron" \
  --cmd "systemctl list-timers 2>/dev/null || true && crontab -l 2>/dev/null || true" \
  --expect-exit-code 0

# Step 3: Write automation script with required header marker
student_exec \
  --step-name "Write automation script with required header marker" \
  --cmd "echo 'PRODUCTION_LINUX_AUTOMATION_MASTERED' > ~/mastery-auto/automation_mastery.sh" \
  --expect-exit-code 0

# Step 4: Verify automation_mastery.sh content
student_exec \
  --step-name "Verify automation_mastery.sh content" \
  --cmd "cat ~/mastery-auto/automation_mastery.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PRODUCTION_LINUX_AUTOMATION_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Automate Linux Operations verified successfully."
