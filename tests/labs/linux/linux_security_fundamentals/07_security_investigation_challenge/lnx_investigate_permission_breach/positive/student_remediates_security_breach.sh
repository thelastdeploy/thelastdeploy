#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Investigate and Remediate Security Privilege Breach
# Module: linux-security-fundamentals
# Section: 07-security-investigation-challenge
# Lab ID: lnx-investigate-permission-breach
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-investigate-permission-breach"

# Step 1: Student audits permissions across the breach scenario folders
student_exec "ls -la ~/security-breach/config ~/security-breach/bin ~/security-breach/sudoers.d" \
    --desc "Student inspects breach scenario files and permissions" \
    --expect-exit 0 \
    --expect-stdout "db_pass.key"

# Step 2: Student secures the database password key file with mode 600
student_exec "chmod 600 ~/security-breach/config/db_pass.key" \
    --desc "Student sets strict 600 permissions on db_pass.key" \
    --expect-exit 0

# Step 3: Student removes dangerous SUID bit from custom_helper binary
student_exec "chmod u-s ~/security-breach/bin/custom_helper" \
    --desc "Student removes SUID bit from custom_helper" \
    --expect-exit 0

# Step 4: Student restricts app_user sudoers rule by removing NOPASSWD: ALL
student_exec "sed -i '/NOPASSWD: ALL/d' ~/security-breach/sudoers.d/app_user" \
    --desc "Student removes NOPASSWD wildcard sudo rule" \
    --expect-exit 0

# Step 5: Student generates the post-mortem incident remediation report
student_exec "printf 'VULNERABILITY_VECTOR: SUDO_NOPASSWD\nBREACH_REMEDIATION: COMPLETED\n' > ~/security-breach/breach_report.txt" \
    --desc "Student writes incident post-mortem report" \
    --expect-exit 0

# Step 6: Student verifies breach_report.txt content
student_exec "cat ~/security-breach/breach_report.txt" \
    --desc "Student verifies post-mortem report content" \
    --expect-exit 0 \
    --expect-stdout "BREACH_REMEDIATION: COMPLETED"

# Step 7: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Security permission breach investigation capstone verified."
