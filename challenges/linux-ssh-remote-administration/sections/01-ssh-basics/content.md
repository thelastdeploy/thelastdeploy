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
