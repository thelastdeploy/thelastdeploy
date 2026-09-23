#!/bin/bash
set -euo pipefail

DB_SVC="$HOME/systemd-challenge/db.service"
APP_SVC="$HOME/systemd-challenge/app.service"

if [ ! -f "$DB_SVC" ] || [ ! -f "$APP_SVC" ]; then
    echo "FAIL: $DB_SVC or $APP_SVC does not exist."
    exit 1
fi

if ! grep -q "ExecStart=" "$DB_SVC"; then
    echo "FAIL: $DB_SVC missing valid ExecStart directive."
    exit 1
fi

if ! grep -q "Requires=db.service" "$APP_SVC" || ! grep -q "After=db.service" "$APP_SVC"; then
    echo "FAIL: $APP_SVC missing Requires=db.service or After=db.service dependency declarations."
    exit 1
fi

echo "PASS: systemd stack recovery capstone verified."
exit 0
