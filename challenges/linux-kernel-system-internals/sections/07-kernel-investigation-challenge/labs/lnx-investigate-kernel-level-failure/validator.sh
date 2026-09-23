#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-failure/kernel_investigation.log" ] && grep -q "KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED" "$HOME/kernel-failure/kernel_investigation.log"; then
    echo "PASS: Investigate Kernel-Level Failure verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Kernel-Level Failure."
    exit 1
fi
