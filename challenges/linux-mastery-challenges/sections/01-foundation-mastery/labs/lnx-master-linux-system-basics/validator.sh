#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-foundation/basics_mastery.log" ] && grep -q "FOUNDATION_SYSTEM_BASICS_MASTERED" "$HOME/mastery-foundation/basics_mastery.log"; then
    echo "PASS: Master Linux System Basics verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Master Linux System Basics."
    exit 1
fi
