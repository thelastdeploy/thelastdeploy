#!/bin/bash
set -euo pipefail

KEY_FILE="$HOME/security-breach/config/db_pass.key"
HELPER_BIN="$HOME/security-breach/bin/custom_helper"
SUDO_FILE="$HOME/security-breach/sudoers.d/app_user"
REPORT_FILE="$HOME/security-breach/breach_report.txt"

# 1. Key file permissions
if [ ! -f "$KEY_FILE" ]; then
    echo "FAIL: $KEY_FILE does not exist."
    exit 1
fi

KEY_PERM=$(stat -c "%a" "$KEY_FILE")
if [ "$KEY_PERM" != "600" ]; then
    echo "FAIL: $KEY_FILE permissions must be 600, currently $KEY_PERM."
    exit 1
fi

# 2. SUID bit check
if [ ! -f "$HELPER_BIN" ]; then
    echo "FAIL: $HELPER_BIN does not exist."
    exit 1
fi

if [ -u "$HELPER_BIN" ]; then
    echo "FAIL: SUID bit is still set on $HELPER_BIN. Use 'chmod u-s'."
    exit 1
fi

# 3. Sudoers file check
if [ ! -f "$SUDO_FILE" ]; then
    echo "FAIL: $SUDO_FILE does not exist."
    exit 1
fi

if grep -q "NOPASSWD: ALL" "$SUDO_FILE"; then
    echo "FAIL: $SUDO_FILE still contains insecure 'NOPASSWD: ALL' rule."
    exit 1
fi

# 4. Report check
if [ ! -f "$REPORT_FILE" ]; then
    echo "FAIL: Post-mortem report $REPORT_FILE does not exist."
    exit 1
fi

REPORT_CONTENT=$(cat "$REPORT_FILE")

if ! echo "$REPORT_CONTENT" | grep -q "VULNERABILITY_VECTOR:"; then
    echo "FAIL: $REPORT_FILE missing 'VULNERABILITY_VECTOR:'."
    exit 1
fi

if ! echo "$REPORT_CONTENT" | grep -q "BREACH_REMEDIATION: COMPLETED"; then
    echo "FAIL: $REPORT_FILE missing 'BREACH_REMEDIATION: COMPLETED'."
    exit 1
fi

echo "PASS: Security permission breach investigation capstone verified."
exit 0
