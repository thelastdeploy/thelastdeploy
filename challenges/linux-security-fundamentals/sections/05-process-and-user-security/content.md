# Process Ownership and User Security

Processes inherit the security credentials (UID/GID) of the account that spawned them. Auditing process ownership prevents unprivileged account escalation and reverse-shell backdoors.

## 1. Auditing Process Ownership

List running processes formatted by user context and executable paths:

```bash
ps -eo pid,user,group,args
```

To list processes owned by a specific service account:
```bash
ps -u www-data
```

## 2. Investigating Suspicious Processes

When investigating potential breaches, check for:
- Processes running under unexpected service accounts (e.g., `nobody` or `guest` spawning shell interpreters `/bin/bash` or netcat `nc`).
- Executables running out of temporary directories like `/tmp`, `/var/tmp`, or `/dev/shm`.

Inspect process metadata in `/proc`:
```bash
# View executable target link
ls -l /proc/<pid>/exe

# View current working directory
ls -l /proc/<pid>/cwd

# View full command line invocation
cat /proc/<pid>/cmdline
```
