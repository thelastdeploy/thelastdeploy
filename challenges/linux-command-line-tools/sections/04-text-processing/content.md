## Text Processing & Manipulation

Linux command-line environments excel at parsing, transforming, and summarizing structured text output using lightweight stream processors.

---

## 1. Field Extraction (`cut` & `awk`)

- **`cut`**: Extracts sections from each line of input based on byte position or character delimiters:
  ```bash
  cut -d',' -f2 /var/log/users.csv
  ```
- **`awk`**: Powerful pattern-scanning tool capable of column extraction and string formatting:
  ```bash
  awk '{print $1}' /var/log/nginx/access.log
  ```

---

## 2. Sorting & Counting (`sort` & `uniq`)

- **`sort`**: Sorts lines of text input (use `-n` for numerical sorting, `-r` for reverse).
- **`uniq -c`**: Counts adjacent duplicate lines (input **must** be sorted first).

Example (Find top occurrences):
```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -n 5
```

---

## Lab Tasks

### Task 1: Process Structured Output (`lnx-process-structured-output`)
1. Start the lab:
   ```bash
   tld start lnx-process-structured-output
   ```
2. Inspect the CSV file `$HOME/text-test/users.csv` (format: `id,username,role`).
3. Extract field 2 (usernames) for all users and save them to `$HOME/text-test/usernames.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Extract Useful Data (`lnx-extract-useful-data`)
1. Start the lab:
   ```bash
   tld start lnx-extract-useful-data
   ```
2. Inspect the IP log file `$HOME/text-test/ips.txt`.
3. Count the number of times IP `192.168.1.50` appears in the log.
4. Save the count integer (e.g., `4`) into `$HOME/text-test/ip_count.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
