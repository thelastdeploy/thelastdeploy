#!/usr/bin/env bash
# ==============================================================================
# Positive Test Flow: Locate configuration files using hierarchy principles
# Module: linux-filesystem-storage
# Section: 01-filesystem-hierarchy
# Lab ID: lnx-locate-system-data
# ==============================================================================
set -euo pipefail

LAB_ID="lnx-locate-system-data"

# Step 1: Student inspects the fhs-test directory structure
student_exec "ls -R ~/fhs-test" \
    --desc "Student inspects subdirectories in ~/fhs-test" \
    --expect-exit 0 \
    --expect-stdout "app.conf"

# Step 2: Student inspects the configuration file contents
student_exec "cat ~/fhs-test/etc_mock/app.conf" \
    --desc "Student reads mock configuration file" \
    --expect-exit 0 \
    --expect-stdout "server_name=tld.local"

# Step 3: Student copies the configuration file to system_config.cfg
student_exec "cp ~/fhs-test/etc_mock/app.conf ~/fhs-test/system_config.cfg" \
    --desc "Student copies configuration file to ~/fhs-test/system_config.cfg" \
    --expect-exit 0

# Step 4: Student confirms the content of the copied file
student_exec "cat ~/fhs-test/system_config.cfg" \
    --desc "Student confirms system_config.cfg content" \
    --expect-exit 0 \
    --expect-stdout "server_name=tld.local"

# Step 5: Student runs tld check to validate completion
student_exec "tld check" \
    --desc "Student runs tld check to validate lab completion" \
    --expect-exit 0 \
    --expect-stdout "PASS: Configuration file located and copied successfully."
