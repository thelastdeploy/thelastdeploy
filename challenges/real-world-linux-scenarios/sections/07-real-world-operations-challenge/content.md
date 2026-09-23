# Failing Production Environment Recovery Capstone

Recover a critical production server suffering from simultaneous multi-subsystem failures: unlinked file space leak, rogue process CPU hog, broken DNS resolution, and misconfigured systemd socket permissions.

In this 130 XP Expert capstone challenge—the largest integrated operational scenario in the Linux track—you are dropped onto a completely failing production server.

### Cascading Outage Symptoms
1. **Web Proxy**: Returning HTTP 502 Bad Gateway due to missing UNIX socket file permissions.
2. **Storage**: Mount point `/var` at 100% capacity due to open unlinked log files.
3. **CPU Contention**: Rogue background process consuming 99% CPU load.
4. **Network**: Microservice backend failing due to broken DNS search path in `/etc/resolv.conf`.
5. **Systemd Supervision**: Service stack missing automated restart directives.

You must navigate the entire stack: Logs -> Processes -> Memory/CPU -> Storage -> Network -> Systemd -> Security -> Verification, and generate an end-to-end master operational recovery sign-off.


---

## Lab Tasks

### Task 1: Recover Failing Production Environment Capstone (`lnx-recover-failing-production-environment`)
1. Start the lab:
   ```bash
   tld start lnx-recover-failing-production-environment
   ```
2. Create directory `$HOME/production-recovery`.
3. Execute multi-layer diagnostic loop across logs, processes, memory/CPU, storage, networking, systemd, and security.
4. Fix unlinked file space leak, kill rogue process, repair DNS resolution, fix socket permissions, and update systemd unit files.
5. Write `CRITICAL_PRODUCTION_ENVIRONMENT_FULLY_RECOVERED` into `$HOME/production-recovery/master_recovery_signoff.log`.
6. Validate your solution:
   ```bash
   tld check
   ```
