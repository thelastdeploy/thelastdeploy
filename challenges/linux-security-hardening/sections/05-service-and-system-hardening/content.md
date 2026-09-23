# Service Sandboxing & System Minimization

System minimization removes unneeded software packages and background daemons to reduce vulnerability surface area. systemd service sandboxing isolates running processes from system resources.

---

## 1. systemd Security Sandboxing Directives

Include security isolation directives inside custom systemd unit files (`[Service]` section):

```ini
[Service]
# Prevent process from elevating privileges via SUID
NoNewPrivileges=true

# Mount /usr, /boot, and /etc read-only for the service
ProtectSystem=strict

# Make /home, /root, and /run/user inaccessible
ProtectHome=yes

# Provide private /tmp directory isolated from other processes
PrivateTmp=yes

# Restrict access to kernel tunables
ProtectKernelTunables=yes
```

Evaluate systemd unit security exposure:

```bash
# Analyze security score of systemd units
systemd-analyze security nginx.service
```

---

## 2. Disabling Non-Essential Daemons

Stop and disable unused background services:

```bash
# Disable legacy or unneeded service
systemctl disable --now bluetooth.service
systemctl disable --now avahi-daemon.service
```

---

## Summary

systemd sandboxing (`NoNewPrivileges`, `ProtectSystem`, `PrivateTmp`) restricts process capabilities if a daemon is compromised.

---

## Lab Tasks

### Task 1: Harden systemd Services with Sandboxing (`lnx-harden-system-services`)
1. Start the lab:
   ```bash
   tld start lnx-harden-system-services
   ```
2. Create directory `$HOME/svc-sec-test`.
3. Document systemd security directives (`NoNewPrivileges=true`, `ProtectSystem=strict`, `PrivateTmp=yes`).
4. Write output summary line `SERVICE_SANDBOXING_HARDENED` to `$HOME/svc-sec-test/sandboxing.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Disable Unnecessary Services and Daemons (`lnx-disable-unnecessary-services`)
1. Start the lab:
   ```bash
   tld start lnx-disable-unnecessary-services
   ```
2. Create directory `$HOME/svc-sec-test`.
3. Identify non-essential daemons and document `systemctl disable --now` procedures.
4. Write summary `UNNECESSARY_SERVICES_DISABLED` into `$HOME/svc-sec-test/disabled_svcs.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
