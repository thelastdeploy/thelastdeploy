#!/bin/bash
set -euo pipefail

SCRIPT="$HOME/bash-challenge/production_tool.sh"
STATUS="$HOME/bash-challenge/status.log"
ENV_FILE="$HOME/bash-challenge/app.env"
LOCK="$HOME/bash-challenge/temp.lock"

if [ ! -f "$SCRIPT" ] || [ ! -x "$SCRIPT" ]; then
    echo "FAIL: $SCRIPT does not exist or is not executable."
    exit 1
fi

if ! grep -q "set -euo pipefail" "$SCRIPT"; then
    echo "FAIL: $SCRIPT does not contain 'set -euo pipefail'."
    exit 1
fi

if [ -f "$LOCK" ]; then
    echo "FAIL: Lock file $LOCK was not cleaned up."
    exit 1
fi

if [ ! -f "$STATUS" ] || ! grep -q "PRODUCTION_AUTOMATION_COMPLETE" "$STATUS"; then
    echo "FAIL: $STATUS does not contain 'PRODUCTION_AUTOMATION_COMPLETE'."
    exit 1
fi

if [ ! -f "$ENV_FILE" ] || ! grep -q "ENV=production" "$ENV_FILE" || ! grep -q "VERSION=2.0" "$ENV_FILE"; then
    echo "FAIL: $ENV_FILE missing required environment configuration entries."
    exit 1
fi

echo "PASS: Production automation capstone tool verified."
exit 0
