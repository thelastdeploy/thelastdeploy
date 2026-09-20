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
