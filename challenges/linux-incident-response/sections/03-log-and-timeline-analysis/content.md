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
2. Create directory `$HOME/timeline-test`.
3. Construct chronological incident timeline combining system auth logs and journal timestamps.
4. Write output line `INCIDENT_TIMELINE_BUILT` to `$HOME/timeline-test/incident_timeline.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Correlate Security Logs and Event Signatures (`lnx-correlate-security-events`)
1. Start the lab:
   ```bash
   tld start lnx-correlate-security-events
   ```
2. Create directory `$HOME/timeline-test`.
3. Correlate SSH authentication logs, sudo execution entries, and file creation events.
4. Write summary line `SECURITY_EVENTS_CORRELATED` to `$HOME/timeline-test/event_correlation.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
