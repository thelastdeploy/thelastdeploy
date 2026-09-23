# Production Server Outage Recovery Capstone Challenge

In this 100 XP Expert capstone challenge, a critical production server is suffering from a major multi-component outage. Several red herrings look suspicious, but specific underlying components are broken. You must execute complete incident response: triage server -> gather evidence -> narrow possibilities -> correlate failures -> isolate root cause -> remediate issues -> verify health -> document post-mortem.

---

## Post-Mortem Incident Response Template

```text
=== PRODUCTION INCIDENT POST-MORTEM ===
Incident Date: 2026-09-23
Impacted Systems: Production Web Application Stack
Symptom: HTTP 502 Bad Gateway / Application Outage
Root Cause: Upstream database dependency failed due to unlinked deleted file disk exhaustion.
Remediation: Terminated stale daemon, freed disk space, restarted database, verified application health.
Verification: All health check endpoints returning HTTP 200 OK.
Status: INCIDENT_RESOLVED_SYSTEM_HEALTHY
```

---

## Summary

Executing complete incident response proves your ability to resolve complex production Linux outages under pressure.

---

## Lab Tasks

### Task 1: Recover Failed Production Server Capstone (`lnx-recover-failed-production-server`)
1. Start the lab:
   ```bash
   tld start lnx-recover-failed-production-server
   ```
2. Create directory `$HOME/incident-capstone`.
3. Diagnose and recover failed production server (isolate root cause, fix broken dependencies/ports/storage, verify service health).
4. Write post-mortem report line `PRODUCTION_INCIDENT_RESOLVED: SYSTEM_HEALTHY` into `$HOME/incident-capstone/post_mortem.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
