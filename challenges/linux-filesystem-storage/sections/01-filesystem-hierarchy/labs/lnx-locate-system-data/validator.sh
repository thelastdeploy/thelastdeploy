#!/bin/bash
# validator.sh — linux-filesystem-storage / 01-filesystem-hierarchy / lnx-locate-system-data
set -euo pipefail

TARGET="$HOME/fhs-test/system_config.cfg"
if [ ! -f "$TARGET" ]; then
  echo "FAIL: File $TARGET not found. Copy the configuration file from ~/fhs-test/etc_mock/app.conf to ~/fhs-test/system_config.cfg."
  exit 1
fi

CONTENT=$(tr -d '\r\n' < "$TARGET" | xargs)
if [ "$CONTENT" != "server_name=tld.local" ]; then
  echo "FAIL: $TARGET content does not match expected app.conf content."
  exit 1
fi

echo "PASS: Configuration file located and copied successfully."
exit 0
