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
2. Perform the required system administration task for `Recover Remote Server SSH Access and Client Config`.
3. Save the resulting verification output or file to the designated lab workspace directory.
4. Validate your solution:
   ```bash
   tld check
   ```
