#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Remote Server SSH Access and Client Config
# Lab: lnx-recover-remote-server
# ==============================================================================

# Step 1: Restore strict permissions on remote .ssh directory to 700
student_exec \
  --step-name "Set remote .ssh directory permissions to 700" \
  --cmd "chmod 700 ~/ssh-challenge/remote_server/.ssh" \
  --expect-exit-code 0

# Step 2: Append client public key to remote authorized_keys and set permissions to 600
student_exec \
  --step-name "Configure authorized_keys with client key and 600 permissions" \
  --cmd "cat ~/ssh-challenge/client_keys/id_ed25519.pub >> ~/ssh-challenge/remote_server/.ssh/authorized_keys && chmod 600 ~/ssh-challenge/remote_server/.ssh/authorized_keys" \
  --expect-exit-code 0

# Step 3: Create client SSH configuration file with alias and 600 permissions
student_exec \
  --step-name "Create client_config with recovery-target alias" \
  --cmd "cat << 'EOF' > ~/ssh-challenge/client_config
Host recovery-target
    HostName 127.0.0.1
    User admin
    Port 22
    IdentityFile ~/ssh-challenge/client_keys/id_ed25519
EOF
chmod 600 ~/ssh-challenge/client_config" \
  --expect-exit-code 0

# Step 4: Write SSH_RECOVERY_COMPLETE to recovery_status.txt
student_exec \
  --step-name "Write recovery status verification file" \
  --cmd "echo 'SSH_RECOVERY_COMPLETE' > ~/ssh-challenge/recovery_status.txt" \
  --expect-exit-code 0

# Step 5: Verify recovery status file content
student_exec \
  --step-name "Verify recovery status file" \
  --cmd "cat ~/ssh-challenge/recovery_status.txt" \
  --expect-exit-code 0 \
  --expect-stdout-contains "SSH_RECOVERY_COMPLETE"

# Step 6: Execute validator verification via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: SSH administration capstone challenge fully verified."
