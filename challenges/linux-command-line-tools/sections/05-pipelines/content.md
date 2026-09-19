## Command Pipelines

The pipe operator (`|`) routes standard output (`stdout`) of one command directly into standard input (`stdin`) of another command.

---

## 1. Building Pipelines

Pipelines allow modular composition of Unix single-purpose tools:

```bash
cat access.log | grep " 500 " | awk '{print $1}' | sort | uniq -c | sort -nr
```

Pipeline Breakdown:
1. `cat access.log`: Reads log file.
2. `grep " 500 "`: Filters HTTP 500 Internal Server Error lines.
3. `awk '{print $1}'`: Extracts the client IP address (column 1).
4. `sort | uniq -c`: Group and count occurrences per IP.
5. `sort -nr`: Sorts numerical results in descending order.

---

## Lab Tasks

### Task 1: Build a Command Pipeline (`lnx-build-command-pipeline`)
1. Start the lab:
   ```bash
   tld start lnx-build-command-pipeline
   ```
2. Inspect the web access log `$HOME/pipe-test/access.log`.
3. Build a pipeline to extract all lines containing `POST`, isolate the IP address (column 1), sort them, and find the IP address with the highest number of POST requests.
4. Save that top IP address (e.g. `10.0.0.99`) into `$HOME/pipe-test/top_poster.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
