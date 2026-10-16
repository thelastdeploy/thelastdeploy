#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate configuration files using find
# Module: linux-fundamentals
# Section: 07-file-searching
# Lab ID: lnx-find-config
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-find-config"

# Step 1: Student uses find to locate app.conf under ~/search-test
student_exec "find \$HOME/search-test -name 'app.conf'" \
    --desc "Student searches for app.conf using find" \
    --expect-exit 0 \
    --expect-stdout "configs/prod/app.conf"

# Step 2: Student inspects the located configuration file
student_exec "cat \$(find \$HOME/search-test -name 'app.conf')" \
    --desc "Student inspects contents of found app.conf" \
    --expect-exit 0 \
    --expect-stdout "database_port=5432"

# Step 3: Student redirects the absolute path into found_conf.txt
student_exec "find \$HOME/search-test -name 'app.conf' > ~/search-test/found_conf.txt" \
    --desc "Student saves absolute path to ~/search-test/found_conf.txt" \
    --expect-exit 0

# Step 4: Intermediate verification by reading back found_conf.txt
student_exec "cat ~/search-test/found_conf.txt" \
    --desc "Student verifies path stored in found_conf.txt" \
    --expect-exit 0 \
    --expect-stdout "search-test/configs/prod/app.conf"

# Step 5: Student runs the TLD validator check
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Config file found successfully"
