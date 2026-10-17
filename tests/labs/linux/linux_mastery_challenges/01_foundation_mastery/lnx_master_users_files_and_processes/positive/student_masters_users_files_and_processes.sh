#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Masters Users, Files, and Processes
# Lab: lnx-master-users-files-and-processes
# ==============================================================================

# Step 1: Ensure mastery-foundation directory exists
student_exec \
  --step-name "Ensure mastery-foundation directory exists" \
  --cmd "mkdir -p ~/mastery-foundation" \
  --expect-exit-code 0

# Step 2: Audit user and process controls
student_exec \
  --step-name "Audit user and process controls" \
  --cmd "id && ps -ef | head -n 5" \
  --expect-exit-code 0

# Step 3: Write access and process mastery marker
student_exec \
  --step-name "Write access and process mastery marker" \
  --cmd "echo 'USERS_FILES_AND_PROCESSES_MASTERED' > ~/mastery-foundation/access_process_mastery.log" \
  --expect-exit-code 0

# Step 4: Verify access_process_mastery.log content
student_exec \
  --step-name "Verify access_process_mastery.log content" \
  --cmd "cat ~/mastery-foundation/access_process_mastery.log" \
  --expect-exit-code 0 \
  --expect-stdout-contains "USERS_FILES_AND_PROCESSES_MASTERED"

# Step 5: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Master Users, Files, and Processes verified successfully."
