#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/mastery-incident/incident_mastery.log" ] && grep -q "PRODUCTION_INCIDENT_INVESTIGATION_MASTERED" "$HOME/mastery-incident/incident_mastery.log"; then
    echo "PASS: Investigate Production Incident verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Investigate Production Incident."
    exit 1
fi
