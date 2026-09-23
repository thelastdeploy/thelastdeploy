#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-modules/module_analysis.txt" ] && grep -q "KERNEL_MODULES_AND_PARAMETERS_ANALYZED" "$HOME/kernel-modules/module_analysis.txt"; then
    echo "PASS: Investigate Kernel Modules verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Kernel Modules."
    exit 1
fi
