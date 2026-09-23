# Multi-Symptom Incident Correlation & Root Cause Analysis

In production incidents, high-stress outages present multiple concurrent symptoms (e.g. database error logs, high CPU usage, network timeout, slow HTTP responses). Root Cause Analysis (RCA) distinguishes the primary trigger from secondary downstream symptoms.

---

## 1. Symptom vs Root Cause Matrix

```text
Primary Root Cause                 Secondary Symptoms (Noise)
+------------------------+         +---------------------------------------+
| Disk 100% Full         | ------> | DB write failures, HTTP 500 errors,   |
| (Log directory filled) |         | high CPU context switching           |
+------------------------+         +---------------------------------------+
```

---

## 2. Correlation Methodology

1. **Chronological Ordering**: Determine which error occurred first in `journalctl` / `dmesg`.
2. **Resource Dependency Mapping**: Determine if service B failed because service A ran out of memory or sockets.
3. **Evidence Verification**: Prove root cause through direct empirical metrics before applying fixes.

---

## Summary

Chronological event ordering and resource dependency mapping isolate true root cause from secondary failure noise.

---

## Lab Tasks

### Task 1: Correlate Multiple Concurrent System Failures (`lnx-correlate-multiple-system-failures`)
1. Start the lab:
   ```bash
   tld start lnx-correlate-multiple-system-failures
   ```
2. Create directory `$HOME/multi-inc-test`.
3. Correlate multiple concurrent log errors across network, storage, and service layers.
4. Write output correlation matrix line `FAILURES_CORRELATED: PRIMARY_CAUSE_ISOLATED` to `$HOME/multi-inc-test/correlation_matrix.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Identify Root Cause of Production Outage (`lnx-identify-root-cause`)
1. Start the lab:
   ```bash
   tld start lnx-identify-root-cause
   ```
2. Create directory `$HOME/multi-inc-test`.
3. Isolate true root cause behind multi-symptom production outage and document evidence.
4. Write output proof line `ROOT_CAUSE_PROVED: DISK_FULL_TRIGGERED_DB_FAIL` into `$HOME/multi-inc-test/root_cause_proof.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
