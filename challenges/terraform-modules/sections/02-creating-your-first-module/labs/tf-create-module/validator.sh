#!/bin/bash
set -euo pipefail
DIR="$HOME/terraform-modules-challenge"
MODULE_DIR="$DIR/modules/file_writer"
if [ ! -d "$MODULE_DIR" ]; then
  echo "FAIL: Child module directory '$MODULE_DIR' not found."
  exit 1
fi
if [ ! -f "$MODULE_DIR/main.tf" ]; then
  echo "FAIL: main.tf file not found in '$MODULE_DIR'."
  exit 1
fi
echo "PASS: Child module created successfully."
exit 0
