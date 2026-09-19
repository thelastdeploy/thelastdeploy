## Command Composition with xargs

The `xargs` command constructs and executes command lines from standard input stream records.

---

## 1. Why Use xargs?

Commands like `grep` or `rm` expect target file arguments, whereas tools like `find` output newline-delimited text to standard output. `xargs` bridge this gap by converting streamed input into positional command arguments.

```bash
find /var/log -type f -name "*.tmp" | xargs rm -f
```

---

## 2. Safe Execution Flags

- **`-0` / `--null`**: Pairs with `find -print0` to safely process filenames containing spaces or special characters.
- **`-I {}`**: Replaces occurrences of `{}` with the input argument for custom argument positioning.

```bash
find $HOME/xargs-test -name "*.log" | xargs grep -i "error"
```

---

## Lab Tasks

### Task 1: Process Multiple Files (`lnx-process-multiple-files`)
1. Start the lab:
   ```bash
   tld start lnx-process-multiple-files
   ```
2. Use `find` and `xargs` to search all `.log` files in `$HOME/xargs-test/batch` for lines containing `FAIL`.
3. Count the total lines output by `grep` across all files and save the total count integer (e.g. `3`) to `$HOME/xargs-test/fail_count.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
