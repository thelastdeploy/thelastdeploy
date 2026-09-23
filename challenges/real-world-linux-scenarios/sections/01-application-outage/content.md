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
1. Start the lab:
   ```bash
   tld start lnx-recover-unavailable-application
   ```
2. Create directory `$HOME/app-outage`.
3. Investigate service crash via journalctl and socket permissions.
4. Restore service availability and verify HTTP 200 responses.
5. Write `UNAVAILABLE_APPLICATION_RECOVERED_SUCCESSFULLY` into `$HOME/app-outage/application_recovery.log`.
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Intermittent Application Failures (`lnx-investigate-intermittent-application`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-intermittent-application
   ```
2. Investigate intermittent application 504 gateway timeouts.
3. Inspect open file descriptor limits (`/proc/[pid]/limits`) and active socket connections.
4. Fix descriptor limit throttling and log `INTERMITTENT_FAILURE_ROOT_CAUSE_DIAGNOSED` into `$HOME/app-outage/intermittent_root_cause.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
