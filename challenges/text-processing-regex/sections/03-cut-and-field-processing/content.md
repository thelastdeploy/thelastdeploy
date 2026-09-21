# Cut and Field Processing

The `cut` utility extracts specific sections or field columns from each line of a file or stream.

## 1. Extracting Character Ranges (`cut -c`)

Select specific character byte positions:
```bash
# Extract characters 1 through 10
cut -c 1-10 data.txt

# Extract the 5th character
cut -c 5 data.txt
```

## 2. Extracting Delimited Fields (`cut -d` and `-f`)

For structured or delimited text (such as CSVs or `/etc/passwd`), specify the field delimiter `-d` and target field number `-f`:

```bash
# Extract field 1 and field 3 separated by commas
cut -d ',' -f 1,3 users.csv

# Extract username (field 1) from colon-delimited /etc/passwd
cut -d ':' -f 1 /etc/passwd
```

---

## Lab Tasks

### Task 1: Extract Character Ranges using Cut (`lnx-extract-data-fields`)
1. Start the lab:
   ```bash
   tld start lnx-extract-data-fields
   ```
2. Extract specific character fields using `cut`.
3. Extract the first 3 characters of each line in `$HOME/text-test/data.txt` and save to `$HOME/text-test/fields.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Process Delimited CSV Files with Cut (`lnx-process-delimited-data`)
1. Start the lab:
   ```bash
   tld start lnx-process-delimited-data
   ```
2. Process colon/comma delimited records using `cut -d`.
3. Extract usernames (field 1) from `$HOME/text-test/passwd_mock` and save to `$HOME/text-test/users.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
