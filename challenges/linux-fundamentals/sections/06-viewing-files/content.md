## Viewing Files

When managing files or reading system logs in a headless Linux environment, we use specialized CLI command-line utilities to inspect contents.

---

## 1. Concat and Print (`cat`)

The `cat` command prints the entire contents of a file directly to the terminal stdout.

```bash
cat short-file.txt
```

> [!TIP]
> Use `cat` only for short files. If you print a very large log file with `cat`, it will flood your terminal screen!

---

## 2. Interactive Viewing (`less`)

For larger files, `less` is the preferred tool. It loads files lazily (without reading the entire file into memory at once) and allows you to scroll up and down page-by-page.

- **Open a file**: `less application.log`
- **Navigate**: Use the **Arrow keys** or **Page Up / Page Down**.
- **Search**: Press `/` followed by the search keyword and hit **Enter**. Use `n` to go to the next match, and `N` to go to the previous.
- **Quit**: Press `q`.

---

## 3. Head and Tail (`head` / `tail`)

To view only the beginning or end of a file:

- **head**: Prints the first 10 lines of a file by default.
  ```bash
  # View first 15 lines (-n 15)
  head -n 15 app.log
  ```
- **tail**: Prints the last 10 lines of a file by default. Excellent for viewing the latest entries in logs.
  ```bash
  # View last 20 lines
  tail -n 20 system.log
  
  # Follow logs in real-time (-f) as new lines are appended
  tail -f system.log
  ```

---

## Lab Tasks

### Task 1: View files using cat
1. Start the lab in your terminal:
   ```bash
   tld start lnx-cat-file
   ```
2. The setup script created `~/view-test/short.txt`. View its contents using the `cat` command.
3. Save the secret code printed inside it to a new file named `code.txt` inside `~/view-test/`:
   ```bash
   echo "LINUX_RULES" > ~/view-test/code.txt
   ```
4. Verify the task to earn your XP:
   ```bash
   tld check
   ```

### Task 2: Search logs using less
1. Start the lab in your terminal:
   ```bash
   tld start lnx-less-logfile
   ```
2. The setup script created `~/view-test/system.log`. Look up the timestamp of the connection timeout error (`ERR_CONN_TIMEOUT`) using `less`.
3. Save the exact timestamp string (`2026-06-10T12:00:00Z`) to a file named `error_time.txt` inside `~/view-test/`:
   ```bash
   echo "2026-06-10T12:00:00Z" > ~/view-test/error_time.txt
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Inspect files with head and tail
1. Start the lab in your terminal:
   ```bash
   tld start lnx-head-tail
   ```
2. The setup script created `~/view-test/growth.txt`. Use `tail` to extract the very last line of the file.
3. Save that last line (exactly `last_line`) to a file named `end.txt` inside `~/view-test/`:
   ```bash
   tail -n 1 ~/view-test/growth.txt > ~/view-test/end.txt
   ```
4. Verify the task:
   ```bash
   tld check
   ```
