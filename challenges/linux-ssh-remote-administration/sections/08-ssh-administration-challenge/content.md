# SSH Administration Capstone Challenge

In this final capstone challenge, you will troubleshoot and recover SSH connectivity for an un-accessible remote server environment.

## Challenge Scenario

A critical remote server is currently refusing SSH key authentication due to misconfigured permissions and missing authorized keys. You must:

1. Restore proper strict permissions on `$HOME/ssh-challenge/remote_server/.ssh` (`700`).
2. Add the public key from `$HOME/ssh-challenge/client_keys/id_ed25519.pub` into `$HOME/ssh-challenge/remote_server/.ssh/authorized_keys`.
3. Enforce strict permissions on `$HOME/ssh-challenge/remote_server/.ssh/authorized_keys` (`600`).
4. Create a client SSH config file at `$HOME/ssh-challenge/client_config` with an alias `recovery-target` (defining `HostName 127.0.0.1`, `User admin`, `Port 22`, and `IdentityFile $HOME/ssh-challenge/client_keys/id_ed25519`) with permissions set to `600`.
5. Output a status verification file at `$HOME/ssh-challenge/recovery_status.txt` containing `SSH_RECOVERY_COMPLETE`.

---

## Lab Tasks

### Task 1: Recover Remote Server SSH Access and Client Config (`lnx-recover-remote-server`)
1. Start the lab:
   ```bash
   tld start lnx-recover-remote-server
   ```
2. Restore directory permissions of `$HOME/ssh-challenge/remote_server/.ssh` to `700` (`chmod 700`).
3. Append public key `$HOME/ssh-challenge/client_keys/id_ed25519.pub` to `$HOME/ssh-challenge/remote_server/.ssh/authorized_keys` and set its permissions to `600` (`chmod 600`).
4. Create client SSH config file `$HOME/ssh-challenge/client_config` defining alias `Host recovery-target` and set its permissions to `600` (`chmod 600`).
5. Write `SSH_RECOVERY_COMPLETE` to `$HOME/ssh-challenge/recovery_status.txt`.
6. Validate your solution:
   ```bash
   tld check
   ```
