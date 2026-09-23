#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-interface/kernel_info.txt" ] && grep -q "KERNEL_VERSION_AND_CMDLINE_INSPECTED" "$HOME/kernel-interface/kernel_info.txt"; then
    echo "PASS: Explore Kernel Information verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Explore Kernel Information."
    exit 1
fi
