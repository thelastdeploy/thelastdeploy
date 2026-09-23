#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/kernel-modules/device_interface.log" ] && grep -q "DEVICE_MAJOR_MINOR_INTERFACE_TRACED" "$HOME/kernel-modules/device_interface.log"; then
    echo "PASS: Trace Device Kernel Interface verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Trace Device Kernel Interface."
    exit 1
fi
