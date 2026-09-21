# Stream Editing with SED

`sed` (Stream Editor) performs basic text transformations on an input stream or file.

## 1. Text Substitution (`s/find/replace/g`)

The primary command in `sed` is substitution:
```bash
sed 's/old_word/new_word/g' config.txt
```

- `s`: Indicates substitution action.
- `/`: Delimiter character (can also use `#` or `|` if finding paths).
- `g`: Global flag (replaces all occurrences on each line, not just the first).

## 2. In-place File Modification (`-i`)

To modify a file directly on disk instead of writing to standard output:
```bash
sed -i 's/PORT=8080/PORT=9090/g' server.conf
```

## 3. Deleting Lines

Delete lines matching a pattern or specific line numbers:

```bash
# Delete line 1 (header line)
sed '1d' data.txt

# Delete lines starting with comments (#)
sed '/^#/d' config.txt
```

---

## Lab Tasks

### Task 1: Transform Configuration Data using SED (`lnx-transform-configuration-data`)
1. Start the lab:
   ```bash
   tld start lnx-transform-configuration-data
   ```
2. Substitute text strings using `sed`.
3. Replace all occurrences of `PORT=80` with `PORT=8080` in `$HOME/text-test/config.ini` and save to `$HOME/text-test/config_updated.ini`.
4. Validate your solution:
   ```bash
   tld check
   ```
