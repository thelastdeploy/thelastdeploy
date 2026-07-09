#!/bin/bash
# validator.sh — nginx-configuration / 03-server-blocks / nginx-enable-server-block
set -euo pipefail

LINK="/etc/nginx/sites-enabled/mysite"
if [ ! -L "$LINK" ] && [ -L "$LINK.conf" ]; then
  LINK="$LINK.conf"
fi

if [ ! -L "$LINK" ]; then
  echo "FAIL: Symbolic link 'mysite' (or 'mysite.conf') not found in /etc/nginx/sites-enabled/"
  exit 1
fi

TARGET=$(readlink -f "$LINK")
if [[ "$TARGET" != "/etc/nginx/sites-available/mysite" ]] && [[ "$TARGET" != "/etc/nginx/sites-available/mysite.conf" ]]; then
  echo "FAIL: Symbolic link points to '$TARGET' instead of '/etc/nginx/sites-available/mysite'."
  exit 1
fi

echo "PASS: Server block symlink is valid."
exit 0
