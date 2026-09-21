# Log Analysis and Event Tracing

Instead of manually reading thousands of raw log lines, effective engineers use text processing tools (`grep`, `awk`, `cut`, `sort`, `uniq`) to extract meaningful insights and trace system faults.

## 1. Extracting Critical Error Patterns

Filter for error severity keywords across system and application logs:

```bash
grep -i -E "error|fatal|panic|exception" /var/log/app/application.log > errors.txt
```

## 2. Tracing Multi-Step Sessions

Distributed systems and multi-threaded applications tag requests with unique Request IDs or Session IDs. To trace the complete lifecycle of a single failed transaction:

```bash
grep "session_id=1042" /var/log/app/trace.log > session_1042_history.log
```

## 3. Counting Error Frequency

Rank error occurrences by frequency to prioritize bug fixes:

```bash
grep -i "error" /var/log/syslog | cut -d ' ' -f 5- | sort | uniq -c | sort -nr | head -n 10
```

---

## Lab Tasks

### Task 1: Extract Errors and Fatal Exceptions from Logs (`lnx-find-errors-in-logs`)
1. Start the lab:
   ```bash
   tld start lnx-find-errors-in-logs
   ```
2. Extract error and fatal log entries using `grep`.
3. Extract all lines matching `ERROR` or `FATAL` from `$HOME/log-test/app.log` and save to `$HOME/log-test/error_summary.log`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace System Event Timelines across Logs (`lnx-trace-system-event`)
1. Start the lab:
   ```bash
   tld start lnx-trace-system-event
   ```
2. Trace system events across log files by session ID.
3. Extract all lines containing `session_id=1042` from `$HOME/log-test/system_trace.log` and save to `$HOME/log-test/session_1042_trace.log`.
4. Validate your solution:
   ```bash
   tld check
   ```
