#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-sec/security_mastery.conf" ] && grep -q "PRODUCTION_SYSTEM_SECURITY_MASTERED" "$HOME/mastery-sec/security_mastery.conf"; then
    echo "PASS: Secure Linux Production System verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Secure Linux Production System."
    exit 1
fi
