# Loop Constructs

Loops enable scripts to repeat actions across multiple items, files, or state changes.

## 1. `for` Loops

Iterate over a list of items:
```bash
for ITEM in server1 server2 server3; do
    echo "Pinging $ITEM..."
done
```

Iterate over a sequence of numbers:
```bash
for i in {1..5}; do
    echo "Attempt $i"
done
```

Iterate over matching files:
```bash
for FILE in /var/log/*.log; do
    echo "Processing file: $FILE"
done
```

## 2. `while` Loops

A `while` loop runs as long as the given condition evaluates to true:
```bash
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count is $COUNT"
    COUNT=$((COUNT + 1))
done
```

Reading a file line-by-line using `while`:
```bash
while IFS= read -r LINE; do
    echo "Line: $LINE"
done < input.txt
```

---

## Lab Tasks

### Task 1: Automate Repetitive Tasks with Loops (`lnx-automate-repetitive-task`)
1. Start the lab:
   ```bash
   tld start lnx-automate-repetitive-task
   ```
2. Create an executable script at `$HOME/script-test/backup_logs.sh`.
3. Use a `for` loop to compress all `.log` files in `$HOME/script-test/logs/` into `.gz` archives using `gzip`.
4. Validate your solution:
   ```bash
   tld check
   ```
