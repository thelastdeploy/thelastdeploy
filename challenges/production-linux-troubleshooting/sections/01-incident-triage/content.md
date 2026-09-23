# Incident Triage & Emergency Baseline Assessment

When a production Linux server experiences an outage or performance degradation, first-responder engineers must perform rapid, non-destructive incident triage to assess system stability, collect diagnostic evidence, and establish a baseline before attempting modifications.

---

## 1. Emergency Incident Triage Flow

```text
+-----------------------+
|  1. Immediate Triage  |  Check load average, disk space, listening ports, panic logs
+-----------+-----------+
            |
            v
+-----------------------+
|  2. Collect Evidence  |  Export journalctl -xb, dmesg, ss -tulpn, top/uptime
+-----------+-----------+
            |
            v
+-----------------------+
|  3. Narrow Scope      |  Isolate affected subsystem (Network, Disk, CPU, Memory, App)
+-----------+-----------+
            |
            v
+-----------------------+
|  4. Root Cause & Fix  |  Remediation, verification, and post-mortem documentation
+-----------------------+
```

---

## 2. The 60-Second Triage Checklist

Run these high-priority diagnostic commands upon entering an active incident:

```bash
# 1. System Load & Uptime
uptime

# 2. Kernel & Hardware Panics
dmesg --level=err,crit,alert,emerg | tail -n 20

# 3. Disk Space & Mount State
df -h
df -i

# 4. Memory & Swap Pressure
free -m

# 5. Network Sockets & Listeners
ss -tulpn

# 6. Failed systemd Units
systemctl --failed
```

---

## Summary

Methodical triage gathers critical evidence and prevents hasty actions that escalate an active production incident.

---

## Lab Tasks

### Task 1: Triage Production Server Incident (`lnx-triage-production-server`)
1. Start the lab:
   ```bash
   tld start lnx-triage-production-server
   ```
2. Create directory `$HOME/triage-test`.
3. Execute first-responder triage checklist on degraded server (`uptime`, `df -h`, `free -m`, `systemctl --failed`).
4. Write triage summary line `PRODUCTION_SERVER_TRIAGED` to `$HOME/triage-test/triage_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Establish Incident State Baseline (`lnx-establish-incident-baseline`)
1. Start the lab:
   ```bash
   tld start lnx-establish-incident-baseline
   ```
2. Create directory `$HOME/triage-test`.
3. Document active incident state metrics prior to system remediation.
4. Write output line `INCIDENT_BASELINE_ESTABLISHED` into `$HOME/triage-test/incident_baseline.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
