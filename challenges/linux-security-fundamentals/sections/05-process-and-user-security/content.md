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

---

## Lab Tasks

### Task 1: Audit Process User Ownership (`lnx-audit-running-processes`)
1. Start the lab:
   ```bash
   tld start lnx-audit-running-processes
   ```
2. Audit process user ownership across system daemons.
3. Identify processes running under the `www-data` user account and save output to `$HOME/sec-test/www_processes.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Suspicious Processes and Backdoors (`lnx-investigate-suspicious-process`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-suspicious-process
   ```
2. Investigate unauthorized background processes.
3. Identify suspicious process names listening on non-standard ports and record details in `$HOME/sec-test/suspicious_proc.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
