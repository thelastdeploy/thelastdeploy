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

---

## Lab Tasks

### Task 1: Inspect Environment Variables (`lnx-inspect-environment`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-environment
   ```
2. Inspect active environment variables in Bash.
3. Save the current user (`$USER`) and shell path (`$SHELL`) to `$HOME/env-test/env_summary.txt` formatted as `USER_NAME=` and `SHELL_PATH=`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Export Environment Variables for Child Processes (`lnx-manage-environment-variables`)
1. Start the lab:
   ```bash
   tld start lnx-manage-environment-variables
   ```
2. Export environment variables for child processes.
3. Create an executable script at `$HOME/env-test/export_cmd.sh` exporting `APP_PORT=8080` and `APP_ENV=staging`.
4. Validate your solution:
   ```bash
   tld check
   ```
