# Text Processing Basics

In Linux, everything is treated as a stream of bytes or lines. Processing text streams efficiency is a foundational skill for system administrators and DevOps engineers.

## 1. Inspecting Subsets of Text (`head` and `tail`)

To view the beginning of a file, use `head`:
```bash
head -n 5 logfile.txt
```

To view the end of a file, use `tail`:
```bash
tail -n 10 logfile.txt
```

## 2. Redirection Operators

- `>` Redirects standard output to a file, overwriting existing content.
- `>>` Redirects standard output, appending content to the end of the file.
- `<` Redirects a file's content into standard input.

```bash
head -n 5 raw.txt > top_five.txt
tail -n 5 raw.txt >> combined.txt
```

## 3. Character Transformation (`tr`)

The `tr` (translate) command modifies or deletes characters from standard input:

```bash
# Convert uppercase to lowercase
cat text.txt | tr 'A-Z' 'a-z'

# Delete specific characters (e.g. carriage returns)
cat file.txt | tr -d '\r'
```

---

## Lab Tasks

### Task 1: Clean Messy Text Using Stream Translation (`lnx-clean-messy-text`)
1. Start the lab:
   ```bash
   tld start lnx-clean-messy-text
   ```
2. Process messy log entries using stream translation (`tr`).
3. Convert lowercase characters to uppercase in `$HOME/text-test/raw.txt` and save output to `$HOME/text-test/clean.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Process Command Output with Head and Redirection (`lnx-process-command-output`)
1. Start the lab:
   ```bash
   tld start lnx-process-command-output
   ```
2. Process command output using `head` and redirection.
3. Extract the first 5 lines of `$HOME/text-test/system.log` and write them to `$HOME/text-test/head_sample.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
