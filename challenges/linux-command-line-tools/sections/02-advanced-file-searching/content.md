## Advanced File Searching

The `find` utility allows Linux administrators to locate files based on flexible evaluation criteria: name patterns, file types, file size ranges, modification timestamps, and permissions.

---

## 1. Searching by File Attributes

- **By Size (`-size`)**:
  - `find /var/log -type f -size +10M`: Files larger than 10 Megabytes.
  - `find /tmp -type f -size -1k`: Files smaller than 1 Kilobyte.
- **By Modification Time (`-mtime` / `-mmin`)**:
  - `find /var/log -type f -mtime -1`: Files modified within the last 24 hours.
  - `find /tmp -type f -mmin -30`: Files modified within the last 30 minutes.

---

## 2. Combining Predicates

Search expressions can be combined using logical operators:
- `-a` (AND - default)
- `-o` (OR)
- `!` or `-not` (NOT)

Example:
```bash
find $HOME/search-test -type f -name "*.log" -size +1M
```

---

## Lab Tasks

### Task 1: Search by File Properties (`lnx-search-by-file-properties`)
1. Start the lab:
   ```bash
   tld start lnx-search-by-file-properties
   ```
2. Locate the single log file inside `$HOME/search-test/logs` that is larger than 5 Megabytes (`+5M`).
3. Save its filename (e.g. `oversized.log`) to `$HOME/search-test/large_log.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Find Relevant Files (`lnx-find-relevant-files`)
1. Start the lab:
   ```bash
   tld start lnx-find-relevant-files
   ```
2. Locate all files ending in `.audit` inside `$HOME/search-test/audits`.
3. Save the total count of `.audit` files found to `$HOME/search-test/audit_count.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
