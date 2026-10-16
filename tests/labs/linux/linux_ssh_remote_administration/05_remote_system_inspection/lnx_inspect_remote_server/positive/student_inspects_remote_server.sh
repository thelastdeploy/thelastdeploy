#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Remote Server Health and Generates Report
# Lab: lnx-inspect-remote-server
# ==============================================================================

# Step 1: Ensure ssh-test directory exists
student_exec \
  --step-name "Create ssh-test directory" \
  --cmd "mkdir -p ~/ssh-test" \
  --expect-exit-code 0

# Step 2: Create audit_remote.sh script that takes hostname argument and writes report
student_exec \
  --step-name "Create audit_remote.sh script" \
  --cmd "cat << 'EOF' > ~/ssh-test/audit_remote.sh
#!/bin/bash
SERVER=\"\${1:-localhost}\"
REPORT_PATH=\"\$HOME/ssh-test/audit_report.txt\"
echo \"=== REMOTE AUDIT: \$SERVER ===\" > \"\$REPORT_PATH\"
echo \"MEMORY_STATUS: OK\" >> \"\$REPORT_PATH\"
echo \"DISK_STATUS: OK\" >> \"\$REPORT_PATH\"
EOF
chmod +x ~/ssh-test/audit_remote.sh" \
  --expect-exit-code 0

# Step 3: Run audit_remote.sh with prod-server to test report generation
student_exec \
  --step-name "Execute audit_remote.sh script" \
  --cmd "~/ssh-test/audit_remote.sh prod-server" \
  --expect-exit-code 0

# Step 4: Verify audit report content
student_exec \
  --step-name "Verify audit report content" \
  --cmd "cat ~/ssh-test/audit_report.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "=== REMOTE AUDIT: prod-server ==="

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote system inspection audit script verified."
