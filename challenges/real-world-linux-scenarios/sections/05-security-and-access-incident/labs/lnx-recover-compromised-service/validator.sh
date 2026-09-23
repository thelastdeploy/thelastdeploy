#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/security-incident/incident_containment.log" ] && grep -q "COMPROMISED_SERVICE_CONTAINED_AND_RECOVERED" "$HOME/security-incident/incident_containment.log"; then
    echo "PASS: Recover Compromised Service verified successfully."
    exit 0
else
    echo "FAIL: Requirement not met for Recover Compromised Service."
    exit 1
fi
