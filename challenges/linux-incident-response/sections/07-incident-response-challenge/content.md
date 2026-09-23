# Compromised Server Digital Forensics Capstone Challenge

In this 100 XP Expert capstone challenge, a production Linux server shows signs of a sophisticated security breach. Rather than simply terminating processes, you must reconstruct the complete attack lifecycle: observe context -> preserve volatile state -> collect process & network evidence -> build chronological timeline -> discover persistence mechanisms -> assess scope -> contain system -> restore safely -> author forensic investigation report.

---

## Forensic Report Template

```text
=== FORENSIC INCIDENT INVESTIGATION REPORT ===
Incident ID: IR-2026-0923
Target Server: prod-app-01
Initial Vector: SSH key compromise via weak user credentials
Attack Timeline:
  - 2026-09-23 02:14:10 UTC: Initial SSH login from 192.168.10.45
  - 2026-09-23 02:15:22 UTC: Dropped reverse shell binary in /tmp/.sys_daemon
  - 2026-09-23 02:16:05 UTC: Created persistent cron entry in /etc/cron.d/updater
Discovered Persistence: /etc/cron.d/updater & unauthorized SSH key in /root/.ssh/authorized_keys
Scope Assessment: Single host compromised; no lateral movement detected.
Containment: Network isolated via iptables; C2 connections dropped.
Remediation: Removed rogue crontab & SSH key; rotated passwords; verified debsums package integrity.
Status: FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED
```

---

## Summary

Executing complete digital forensics and incident response proves your ability to reconstruct attack lifecycles and safely recover compromised Linux systems.

---

## Lab Tasks

### Task 1: Investigate Compromised Server Forensic Capstone (`lnx-investigate-compromised-server`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-compromised-server
   ```
2. Create directory `$HOME/ir-capstone`.
3. Perform end-to-end digital forensics and incident response (observe, preserve, collect evidence, build timeline, discover persistence, contain, restore).
4. Write master forensic report line `FORENSIC_INVESTIGATION_COMPLETE_SYSTEM_SECURED` into `$HOME/ir-capstone/forensic_investigation.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
