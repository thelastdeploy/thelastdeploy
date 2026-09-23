#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-foundation/access_process_mastery.log" ] && grep -q "USERS_FILES_AND_PROCESSES_MASTERED" "$HOME/mastery-foundation/access_process_mastery.log"; then
    echo "PASS: Master Users, Files, and Processes verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Master Users, Files, and Processes."
    exit 1
fi
