#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/linux-mastery/grand_mastery_completion.log" ] && grep -q "GRAND_LINUX_MASTERY_TRACK_COMPLETED_SUCCESSFULLY" "$HOME/linux-mastery/grand_mastery_completion.log"; then
    echo "PASS: Complete Linux Mastery Grand Capstone verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Complete Linux Mastery Grand Capstone."
    exit 1
fi
