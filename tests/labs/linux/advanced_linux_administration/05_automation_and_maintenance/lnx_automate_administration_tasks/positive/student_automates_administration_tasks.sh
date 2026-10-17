#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Automates Administration Tasks
# Lab: lnx-automate-administration-tasks
# ==============================================================================

# Step 1: Ensure admin-auto directory exists
student_exec \
  --step-name "Ensure admin-auto directory exists" \
  --cmd "mkdir -p ~/admin-auto" \
  --expect-exit-code 0

# Step 2: Audit system log directories and disk state
student_exec \
  --step-name "Audit system log directories and disk state" \
  --cmd "df -h && ls -la /var/log 2>/dev/null | head -n 5 || true" \
  --expect-exit-code 0

# Step 3: Write automation tasks script marker
student_exec \
  --step-name "Write automation tasks script marker" \
  --cmd "echo 'ADMINISTRATION_TASKS_AUTOMATED' > ~/admin-auto/automation_tasks.sh" \
  --expect-exit-code 0

# Step 4: Verify automation_tasks.sh content
student_exec \
  --step-name "Verify automation_tasks.sh content" \
  --cmd "cat ~/admin-auto/automation_tasks.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "ADMINISTRATION_TASKS_AUTOMATED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Automate Administration Tasks verified successfully."
