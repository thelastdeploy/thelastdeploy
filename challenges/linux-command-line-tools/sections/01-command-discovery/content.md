## Command Discovery & Types

In Linux, shell commands originate from several sources: shell built-in commands (`cd`, `echo`), executable binaries (`/bin/grep`, `/usr/bin/python3`), shell aliases, and function definitions.

---

## 1. Locating Executables (`which` & `whereis`)

- **`which`**: Resolves the exact binary path executed when a command is typed by searching `$PATH`.
  ```bash
  which python3
  # Output: /usr/bin/python3
  ```
- **`whereis`**: Locates binary, source file, and manual page locations for a command.
  ```bash
  whereis grep
  # Output: grep: /usr/bin/grep /usr/share/man/man1/grep.1.gz
  ```

---

## 2. Inspecting Command Types (`type` & `whatis`)

- **`type`**: Indicates how a command name would be interpreted (builtin, alias, function, or disk file).
  ```bash
  type cd
  # Output: cd is a shell builtin
  ```
- **`whatis`**: Displays single-line manual descriptions for a tool.
  ```bash
  whatis tar
  ```

---

## Lab Tasks

### Task 1: Discover Command Location (`lnx-discover-command-location`)
1. Start the lab:
   ```bash
   tld start lnx-discover-command-location
   ```
2. Find the absolute path of the `grep` binary on your system using `which grep`.
3. Save the full binary path to `$HOME/cli-test/grep_location.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Command Options (`lnx-inspect-command-options`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-command-options
   ```
2. Determine if `cd` is a shell builtin or an external binary using `type cd`.
3. Save the single word `builtin` to `$HOME/cli-test/cd_type.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
