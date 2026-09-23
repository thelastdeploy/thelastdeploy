#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-interface/proc_sys_analysis.txt" ] && grep -q "PROC_SYS_SUBSYSTEM_HIERARCHY_ANALYZED" "$HOME/kernel-interface/proc_sys_analysis.txt"; then
    echo "PASS: Investigate procfs and sysfs verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate procfs and sysfs."
    exit 1
fi
