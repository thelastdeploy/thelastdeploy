#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Queries Systemd Journal by Unit and Time
# Lab: lnx-query-system-journal
# ==============================================================================

# Step 1: Ensure log-test directory exists
student_exec \
  --step-name "Ensure log-test directory exists" \
  --cmd "mkdir -p ~/log-test" \
  --expect-exit-code 0

# Step 2: Create journal_query_cmd.sh script with correct query options
student_exec \
  --step-name "Create journal_query_cmd.sh script" \
  --cmd "cat << 'EOF' > ~/log-test/journal_query_cmd.sh
#!/bin/bash
journalctl -u ssh.service --since '1 hour ago'
EOF
chmod +x ~/log-test/journal_query_cmd.sh" \
  --expect-exit-code 0

# Step 3: Verify script content and executable permission
student_exec \
  --step-name "Verify journal_query_cmd.sh exists and is executable" \
  --cmd "test -x ~/log-test/journal_query_cmd.sh && cat ~/log-test/journal_query_cmd.sh" \
  --expect-exit-code 0 \
  --expect-stdout-contains "journalctl -u ssh.service --since"

# Step 4: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Journalctl query command syntax verified."
