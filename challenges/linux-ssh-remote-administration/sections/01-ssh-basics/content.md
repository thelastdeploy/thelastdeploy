# SSH Connection Basics

Secure Shell (SSH) is a network protocol that gives system administrators a secure, encrypted way to access remote servers over unsecured networks.

## 1. Interactive Remote Connections

To establish an interactive shell session on a remote Linux server:

```bash
ssh user@remote.example.com
```

If the remote SSH server listens on a non-standard port (default is 22), use the `-p` flag:
```bash
ssh -p 2222 admin@192.168.1.100
```

## 2. Non-Interactive Remote Command Execution

You can run commands directly on a remote server without initiating an interactive shell by appending the command string to the SSH connection invocation:

```bash
ssh user@remote.example.com "uptime"
ssh user@remote.example.com "df -h /"
```

This capability makes SSH ideal for automated scripting and remote system auditing.

---

## Lab Tasks

### Task 1: Connect to a Remote Host via SSH (`lnx-connect-to-remote-host`)
1. Start the lab:
   ```bash
   tld start lnx-connect-to-remote-host
   ```
2. Perform the required system administration task for `Connect to a Remote Host via SSH`.
3. Save the resulting verification output or file to the designated lab workspace directory.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run Commands Remotely over SSH (`lnx-run-remote-command`)
1. Start the lab:
   ```bash
   tld start lnx-run-remote-command
   ```
2. Perform the required system administration task for `Run Commands Remotely over SSH`.
3. Save the resulting verification output or file to the designated lab workspace directory.
4. Validate your solution:
   ```bash
   tld check
   ```
