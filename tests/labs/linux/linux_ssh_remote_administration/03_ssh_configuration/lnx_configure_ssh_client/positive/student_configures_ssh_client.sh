#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Configures SSH Client Host Aliases
# Lab: lnx-configure-ssh-client
# ==============================================================================

# Step 1: Ensure ssh-test/config_dir directory exists
student_exec \
  --step-name "Create config_dir directory" \
  --cmd "mkdir -p ~/ssh-test/config_dir" \
  --expect-exit-code 0

# Step 2: Create client SSH configuration file with host alias and strict permissions
student_exec \
  --step-name "Create SSH config file" \
  --cmd "cat << 'EOF' > ~/ssh-test/config_dir/config
Host prod-web
    HostName 10.0.1.100
    User devops
    Port 2222
EOF
chmod 600 ~/ssh-test/config_dir/config" \
  --expect-exit-code 0

# Step 3: Verify config permissions are 600
student_exec \
  --step-name "Verify config file permissions" \
  --cmd "stat -c '%a' ~/ssh-test/config_dir/config" \
  --expect-exit-code 0 \
  --expect-stdout-contains "600"

# Step 4: Verify config file content
student_exec \
  --step-name "Verify config file content" \
  --cmd "cat ~/ssh-test/config_dir/config" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Host prod-web"

# Step 5: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SSH client configuration file validated successfully."
