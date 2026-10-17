# Application Outage Scenarios

Triage and recover from complete application unavailabilities and intermittent HTTP 5xx errors driven by hidden environment, permissions, or systemd socket state issues.

In real-world production outages, application error responses rarely state the true root cause directly. A generic '502 Bad Gateway' or '500 Internal Server Error' can stem from UNIX socket file permission mismatches, missing environment variables, truncated database connection pools, or misconfigured SELinux/AppArmor profiles.

### Diagnostic Flow
1. **Application & Proxy Logs**: `/var/log/nginx/error.log`, `journalctl -u app.service -e`.
2. **Socket & Process Status**: `ss -xlp`, `systemctl status app.service`.
3. **Environment & Filesystem**: `/proc/[pid]/environ`, file permissions on socket paths.

---

## Lab Tasks

### Task 1: Recover Unavailable Application (`lnx-recover-unavailable-application`)
1. Start the lab session:
   ```bash
   tld start lnx-recover-unavailable-application
   ```
2. Create the destination directory for outage reports:
   ```bash
   mkdir -p "$HOME/app-outage"
   ```
3. Investigate the service crash using `journalctl` and check UNIX domain socket path permissions.
4. Restore service availability and verify application response health.
5. Record the recovery verification marker into `$HOME/app-outage/application_recovery.log`:
   ```bash
   echo "UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY" > "$HOME/app-outage/application_recovery.log"
   ```
6. Verify file contents:
   ```bash
   cat "$HOME/app-outage/application_recovery.log"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Intermittent Application Failures (`lnx-investigate-intermittent-application`)
1. Start the lab session:
   ```bash
   tld start lnx-investigate-intermittent-application
   ```
2. Ensure the outage reports directory exists:
   ```bash
   mkdir -p "$HOME/app-outage"
   ```
3. Investigate intermittent application 504 gateway timeouts by inspecting open file descriptor limits (`/proc/[pid]/limits`) and active socket connections (`ss -tulpn`).
4. Remediate descriptor limit throttling and record the root cause diagnosis marker into `$HOME/app-outage/intermittent_root_cause.txt`:
   ```bash
   echo "INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED" > "$HOME/app-outage/intermittent_root_cause.txt"
   ```
5. Verify file contents:
   ```bash
   cat "$HOME/app-outage/intermittent_root_cause.txt"
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
