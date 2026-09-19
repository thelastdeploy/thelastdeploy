## Command Line Investigation

Real-world production log files are often messy, combining timestamps, thread IDs, log levels, stack traces, and arbitrary JSON payloads.

---

## 1. Multi-Step CLI Parsing Workflow

To extract actionable metrics from unstructured log dumps:
1. Filter noise using `grep` or `grep -E`.
2. Extract target fields using `awk` or `cut`.
3. Sort and deduplicate values using `sort | uniq -c`.
4. Isolate top offenders using `sort -nr | head`.

---

## Lab Tasks

### Task 1: Investigate Messy Log (`lnx-investigate-messy-log`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-messy-log
   ```
2. Inspect `$HOME/cli-investigation/raw_dump.log`.
3. Parse the log file to identify the user ID associated with the highest number of failed authentication attempts (`AUTH_FAILURE`).
4. Save that user ID string (e.g. `user_88`) into `$HOME/cli-investigation/bad_user.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
