#!/bin/bash
# validator.sh — linux-filesystem-storage / 03-links-and-inodes / lnx-create-symbolic-link
set -euo pipefail

LINK="$HOME/link-test/current_config.conf"
TARGET="$HOME/link-test/configs/app_v2.conf"

if [ ! -L "$LINK" ]; then
  echo "FAIL: $LINK is not a symbolic link. Run 'ln -s ~/link-test/configs/app_v2.conf ~/link-test/current_config.conf'."
  exit 1
fi

DEST=$(readlink -f "$LINK" || true)
EXPECTED=$(readlink -f "$TARGET" || true)

if [ "$DEST" != "$EXPECTED" ]; then
  echo "FAIL: Symlink destination ($DEST) does not match expected target ($EXPECTED)."
  exit 1
fi

echo "PASS: Symbolic link successfully verified."
exit 0
