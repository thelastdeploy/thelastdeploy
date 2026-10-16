# Functions and Modular Scripts

Functions group commands into reusable blocks within your script, improving readability and maintainability.

## 1. Function Syntax

Define a function using the following syntax:
```bash
log_message() {
    local LEVEL="$1"
    local MSG="$2"
    echo "[$LEVEL] $MSG"
}
```

Call the function like a standard command:
```bash
log_message "INFO" "Application started successfully"
```

## 2. Local Variables

By default, variables created inside functions are global. Use the `local` keyword to scope variables inside functions:
```bash
my_func() {
    local TEMP_VAR="scoped value"
    echo "$TEMP_VAR"
}
```

## 3. Function Return Values

Functions in Bash return an exit status code between 0 and 255 using `return`:
```bash
is_even() {
    local NUM="$1"
    if [ $((NUM % 2)) -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

if is_even 4; then
    echo "4 is even"
fi
```

---

## Lab Tasks

### Task 1: Build a Script Helper Toolkit (`lnx-build-script-toolkit`)
1. Start the lab:
   ```bash
   tld start lnx-build-script-toolkit
   ```
2. Create an executable script library at `$HOME/script-test/toolkit.sh`.
3. Implement a reusable helper function named `is_file_present` that accepts a file path as `$1`, returning exit code `0` if the file exists and `1` if it is missing.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Create Reusable Functions (`lnx-create-reusable-functions`)
1. Start the lab:
   ```bash
   tld start lnx-create-reusable-functions
   ```
2. Create a script library at `$HOME/script-test/log_helper.sh` containing a reusable function named `log_message`.
3. The function should take two arguments (level and message) and format output as `[LEVEL] Message`.
4. Validate your solution:
   ```bash
   tld check
   ```
