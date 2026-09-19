#!/bin/bash
# validator.sh — linux-filesystem-storage / 07-storage-challenge / lnx-recover-disk-space
set -euo pipefail

ACTIVE_APP="$HOME/storage-challenge/active_app.log"
ACTIVE_SERVICE="$HOME/storage-challenge/active_service.log"
ARCHIVE_DIR="$HOME/storage-challenge/archives"

if [ ! -f "$ACTIVE_APP" ] || [ ! -f "$ACTIVE_SERVICE" ]; then
  echo "FAIL: Active log files (active_app.log / active_service.log) were accidentally deleted!"
  exit 1
fi

DUMP_COUNT=$(find "$ARCHIVE_DIR" -type f \( -name "*.dump" -o -name "*.tar.gz" \) 2>/dev/null | wc -l)
if [ "$DUMP_COUNT" -gt 0 ]; then
  echo "FAIL: Stale log archives still exist in $ARCHIVE_DIR ($DUMP_COUNT files remaining). Remove crash_2025.dump and old_logs.tar.gz."
  exit 1
fi

echo "PASS: Disk space recovered successfully while preserving active service logs!"
exit 0
