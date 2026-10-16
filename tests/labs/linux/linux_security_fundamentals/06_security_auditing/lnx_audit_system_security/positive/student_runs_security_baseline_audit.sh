#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Perform System Security Baseline Audit
# Module: linux-security-fundamentals
# Section: 06-security-auditing
# Lab ID: lnx-audit-system-security
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-audit-system-security"

# Step 1: Student creates the baseline security audit script
student_exec "cat <<'EOF' > ~/sec-test/audit_script.sh
#!/bin/bash
set -euo pipefail
REPORT=\"\$HOME/sec-test/audit_findings.txt\"
UID_COUNT=\$(awk -F: '(\$3 == 0) { print \$1 }' /etc/passwd | wc -l | tr -d ' ')
SUDO_USERS=\$( (grep -roh 'NOPASSWD: ALL' /etc/sudoers /etc/sudoers.d/ 2>/dev/null || true) | wc -l | tr -d ' ')
WW_COUNT=\$(find /tmp -type f -perm -0002 2>/dev/null | wc -l | tr -d ' ' || echo \"0\")

cat <<FINDINGS > \"\$REPORT\"
UID_ZERO_COUNT:\$UID_COUNT
UNSECURE_SUDO_USERS:\$SUDO_USERS
WORLD_WRITABLE_COUNT:\$WW_COUNT
FINDINGS
EOF" \
    --desc "Student writes security baseline audit script" \
    --expect-exit 0

# Step 2: Student sets executable permissions on audit_script.sh
student_exec "chmod +x ~/sec-test/audit_script.sh" \
    --desc "Student marks audit script as executable" \
    --expect-exit 0

# Step 3: Student runs audit script and verifies generated report
student_exec "~/sec-test/audit_script.sh && cat ~/sec-test/audit_findings.txt" \
    --desc "Student runs audit script and inspects findings" \
    --expect-exit 0 \
    --expect-stdout "UID_ZERO_COUNT:"

# Step 4: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System security baseline audit verified."
