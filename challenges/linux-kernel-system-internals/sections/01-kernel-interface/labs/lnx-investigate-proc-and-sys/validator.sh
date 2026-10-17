#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/kernel-interface/proc_sys_analysis.txt"

if [ ! -f "$TARGET" ]; then
    echo "FAIL: $TARGET does not exist."
    exit 1
fi

if [ ! -s "$TARGET" ]; then
    echo "FAIL: $TARGET is empty."
    exit 1
fi

if ! grep -q "PROC_SYS_SUBSYSTEM_HIERARCHY_ANALYZED" "$TARGET"; then
    echo "FAIL: Requirement not met for Investigate procfs and sysfs."
    exit 1
fi

echo "PASS: Investigate procfs and sysfs verified successfully."
exit 0
