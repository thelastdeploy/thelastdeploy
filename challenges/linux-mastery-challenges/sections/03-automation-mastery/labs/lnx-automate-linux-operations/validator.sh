#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-auto/automation_mastery.sh" ] && grep -q "PRODUCTION_LINUX_AUTOMATION_MASTERED" "$HOME/mastery-auto/automation_mastery.sh"; then
    echo "PASS: Automate Linux Operations verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Automate Linux Operations."
    exit 1
fi
