# Chronological Timeline Construction & Log Correlation

Reconstructing an attack requires constructing a unified, chronological timeline of events by correlating authentication logs, system journal entries, web access logs, and file modification timestamps.

---

## 1. Timeline Reconstruction Sources

```text
Authentication Logs          System Journal                 File Timestamps (MACB)
(/var/log/auth.log)        (journalctl --since)            (mtime / ctime / atime)
        |                           |                                 |
        +---------------------------+---------------------------------+
                                    |
                                    v
                 +--------------------------------------+
                 | Unified Incident Timeline           |
                 | (Chronological Attack Order)        |
                 +--------------------------------------+
```

---

## 2. Analyzing Authentication & System Logs

```bash
# Correlate SSH authentication events
grep -E "Accepted|Failed|Invalid" /var/log/auth.log

# Inspect system logs around incident timeframe
journalctl --since "2026-09-23 00:00:00" --until "2026-09-23 12:00:00" -o short-iso

# Locate recently modified files across filesystem
find /etc /var /usr -mtime -1 -type f 2>/dev/null
```

---

## Summary

Combining authentication logs (`auth.log`), journal entries, and file modification timestamps (`find -mtime`) produces a master incident timeline.

---

## Lab Tasks

### Task 1: Build Chronological Incident Timeline (`lnx-build-incident-timeline`)
1. Start the lab:
   ```bash
   tld start lnx-build-incident-timeline
   ```
2. Create directory `$HOME/timeline-test`:
   ```bash
   mkdir -p ~/timeline-test
   ```
3. Inspect authentication events and recent system entries:
   ```bash
   grep -E "Accepted|Failed|Invalid" /var/log/auth.log 2>/dev/null || true
   journalctl -n 20 --no-pager 2>/dev/null || true
   ```
4. Record timeline marker into `$HOME/timeline-test/incident_timeline.txt`:
   ```bash
   echo "INCIDENT_TIMELINE_BUILT" > ~/timeline-test/incident_timeline.txt
   cat ~/timeline-test/incident_timeline.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Correlate Security Logs and Event Signatures (`lnx-correlate-security-events`)
1. Start the lab:
   ```bash
   tld start lnx-correlate-security-events
   ```
2. Create directory `$HOME/timeline-test`:
   ```bash
   mkdir -p ~/timeline-test
   ```
3. Correlate sudo execution and SSH authentication signatures:
   ```bash
   grep -E "sudo:|sshd\[" /var/log/auth.log 2>/dev/null || true
   find /tmp /var/tmp -maxdepth 2 -type f 2>/dev/null || true
   ```
4. Record event correlation marker into `$HOME/timeline-test/event_correlation.txt`:
   ```bash
   echo "SECURITY_EVENTS_CORRELATED" > ~/timeline-test/event_correlation.txt
   cat ~/timeline-test/event_correlation.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

