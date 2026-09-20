# Environment Variables

Environment variables are dynamic key-value pairs stored within the shell's memory space that govern process behavior, system paths, user preferences, and application settings.

## 1. Inspecting Environment Variables

To list all exported environment variables:
```bash
printenv
# or
env
```

To view a specific environment variable:
```bash
echo "$USER"
echo "$PATH"
echo "$HOME"
```

## 2. Shell Variables vs Environment Variables

- **Shell Variable**: Local to the current shell instance. Child processes will NOT inherit it.
  ```bash
  MY_VAR="local_value"
  ```
- **Environment Variable**: Exported so child processes inherit it.
  ```bash
  export MY_VAR="global_value"
  ```

## 3. Removing Environment Variables (`unset`)

To clear an environment variable from the current shell session:
```bash
unset MY_VAR
```
