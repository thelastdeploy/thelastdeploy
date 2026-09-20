# SSH Administration Capstone Challenge

In this final capstone challenge, you will troubleshoot and recover SSH connectivity for an un-accessible remote server environment.

## Challenge Scenario

A critical remote server is currently refusing SSH key authentication due to misconfigured permissions and missing authorized keys. You must:

1. Restore proper strict permissions on `$HOME/ssh-challenge/remote_server/.ssh` (`700`).
2. Add the public key from `$HOME/ssh-challenge/client_keys/id_ed25519.pub` into `$HOME/ssh-challenge/remote_server/.ssh/authorized_keys`.
3. Enforce strict permissions on `$HOME/ssh-challenge/remote_server/.ssh/authorized_keys` (`600`).
4. Create a client SSH config file at `$HOME/ssh-challenge/client_config` with an alias `recovery-target` (defining `HostName 127.0.0.1`, `User admin`, `Port 22`, and `IdentityFile $HOME/ssh-challenge/client_keys/id_ed25519`) with permissions set to `600`.
5. Output a status verification file at `$HOME/ssh-challenge/recovery_status.txt` containing `SSH_RECOVERY_COMPLETE`.
