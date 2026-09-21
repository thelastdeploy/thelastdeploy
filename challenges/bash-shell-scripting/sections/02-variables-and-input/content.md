# Variables and User Input

Variables store values for reuse throughout your script. Bash supports string, integer, and array variables.

## 1. Defining and Using Variables

Define variables without spaces around the `=` sign:
```bash
APP_NAME="devlab"
PORT=8080
echo "Starting $APP_NAME on port $PORT..."
```

## 2. Positional Arguments

Arguments passed to a script on the command line are accessed via positional variables:
- `$1`, `$2`, `$3`: First, second, third positional argument.
- `$0`: Name of the script.
- `$#`: Total count of arguments provided.
- `$@`: All positional arguments as a list.

Example usage:
```bash
./deploy.sh frontend production
```
Inside `deploy.sh`: `$1` is `frontend` and `$2` is `production`.

## 3. Reading User Input

Use the `read` command to capture interactive user input:
```bash
read -p "Enter environment name: " ENV_NAME
echo "Selected environment: $ENV_NAME"
```

The `-p` flag displays a prompt before waiting for input.

---

## Lab Tasks

### Task 1: Build an Interactive Shell Script (`lnx-build-interactive-script`)
1. Start the lab:
   ```bash
   tld start lnx-build-interactive-script
   ```
2. Create an interactive script at `$HOME/script-test/interactive.sh` that prompts the user using `read -p` to enter a username.
3. Ensure the script prints `Welcome, <username>!` based on the entered input.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Work with Script Variables and Arguments (`lnx-work-with-script-variables`)
1. Start the lab:
   ```bash
   tld start lnx-work-with-script-variables
   ```
2. Create an executable script at `$HOME/script-test/vars.sh` that accepts positional parameters `$1` (Name) and `$2` (Role).
3. Ensure the script prints `User: $1, Role: $2` when run with positional arguments.
4. Validate your solution:
   ```bash
   tld check
   ```
