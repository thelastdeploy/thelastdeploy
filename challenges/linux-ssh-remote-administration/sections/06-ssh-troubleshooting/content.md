# SSH Troubleshooting and Debugging

When SSH connections fail, diagnosing the underlying cause quickly is vital for system recovery.

## 1. Verbose Debugging Mode (`-v`, `-vv`, `-vvv`)

Increase verbosity to trace key negotiation, cipher selection, authentication handshakes, and server responses:

```bash
# Level 1 verbosity (basic connection progress)
ssh -v user@remote.example.com

# Level 3 maximum verbosity (detailed internal handshake debugging)
ssh -vvv user@remote.example.com
```

## 2. Common SSH Failure Scenarios

1. **`Permission denied (publickey)`**:
   - The remote server rejected all presented keys.
   - Cause: Key not added to `authorized_keys`, or bad permissions on `~/.ssh` (`700`) or `authorized_keys` (`600`).
2. **`Connection refused`**:
   - The remote SSH service (`sshd`) is stopped, or port 22 is blocked by a firewall.
3. **`Host key verification failed`**:
   - The remote host key changed (or spoofing detected). Clear obsolete keys using:
     ```bash
     ssh-keygen -R remote.example.com
     ```

## 3. Fixing Strict Permissions

OpenSSH refuses authentication if directory/file permissions are world-writable:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
```
