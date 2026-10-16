#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Build a System Health Monitoring Script
# Module: bash-shell-scripting
# Section: 08-shell-scripting-challenge
# Lab ID: lnx-build-system-health-script
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-build-system-health-script"

# Step 1: Student writes system_health.sh with strict options and argument validation
student_exec "cat << 'EOF' > ~/script-challenge/system_health.sh
#!/bin/bash
set -euo pipefail

REPORT_FILE=\"\${1:-}\"

if [ -z \"\$REPORT_FILE\" ]; then
    echo \"Error: Report path argument required.\" >&2
    exit 1
fi

cat << 'REPORT' > \"\$REPORT_FILE\"
=== SYSTEM HEALTH REPORT ===
DISK_STATUS: OK
SYSTEM_STATUS: HEALTHY
REPORT

echo \"Report generated at \$REPORT_FILE\"
exit 0
EOF" \
    --desc "Student writes system_health.sh with shebang and report generator" \
    --expect-exit 0

# Step 2: Student inspects the script contents
student_exec "cat ~/script-challenge/system_health.sh" \
    --desc "Student inspects system_health.sh contents" \
    --expect-exit 0 \
    --expect-stdout "set -euo pipefail"

# Step 3: Student adds execution permission
student_exec "chmod +x ~/script-challenge/system_health.sh" \
    --desc "Student marks system_health.sh executable" \
    --expect-exit 0

# Step 4: Student tests error handling with no arguments
student_exec "~/script-challenge/system_health.sh || echo 'Exited with non-zero code as expected'" \
    --desc "Student verifies missing argument exit code 1" \
    --expect-exit 0 \
    --expect-stdout "Exited with non-zero code as expected"

# Step 5: Student executes system_health.sh with report target
student_exec "~/script-challenge/system_health.sh ~/script-challenge/report.txt" \
    --desc "Student executes system_health.sh with valid report path" \
    --expect-exit 0 \
    --expect-stdout "Report generated"

# Step 6: Student confirms report file contents
student_exec "cat ~/script-challenge/report.txt" \
    --desc "Student verifies report headers and health metrics" \
    --expect-exit 0 \
    --expect-stdout "SYSTEM_STATUS: HEALTHY"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: System health monitoring capstone challenge script fully verified."
