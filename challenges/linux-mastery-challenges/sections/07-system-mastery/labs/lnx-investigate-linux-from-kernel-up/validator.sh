#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-internals/internals_mastery.log" ] && grep -q "KERNEL_AND_SYSTEM_INTERNALS_MASTERED" "$HOME/mastery-internals/internals_mastery.log"; then
    echo "PASS: Investigate Linux From Kernel Up verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Linux From Kernel Up."
    exit 1
fi
