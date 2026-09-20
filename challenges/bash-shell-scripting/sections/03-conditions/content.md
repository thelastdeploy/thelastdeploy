# Conditional Statements

Conditional statements allow scripts to make decisions based on system state, command outputs, or user input.

## 1. Syntax of `if` Statements

```bash
if [ condition ]; then
    # commands executed if condition is true
elif [ another_condition ]; then
    # commands executed if another_condition is true
else
    # fallback commands
fi
```

*Note: Always leave spaces inside the brackets `[ condition ]`.*

## 2. Common Operators

### File Tests
- `-f FILE`: True if FILE exists and is a regular file.
- `-d FILE`: True if FILE exists and is a directory.
- `-x FILE`: True if FILE exists and is executable.
- `-s FILE`: True if FILE exists and has size greater than 0.

### Integer Comparisons
- `A -eq B`: Equal
- `A -ne B`: Not equal
- `A -gt B`: Greater than
- `A -ge B`: Greater than or equal to
- `A -lt B`: Less than
- `A -le B`: Less than or equal to

### String Comparisons
- `STR1 = STR2`: Strings match
- `STR1 != STR2`: Strings do not match
- `-z STR`: String length is zero (empty)
- `-n STR`: String length is non-zero
