# Shell Scripts Basics

A shell script is a text file containing a sequence of commands executed by a shell (such as Bash). Writing shell scripts allows you to automate repetitive tasks, manage system configurations, and streamline workflows.

## 1. The Shebang (`#!/bin/bash`)

The first line of a Bash script is typically the **shebang**:
```bash
#!/bin/bash
```
The shebang tells the operating system which interpreter to use when executing the file. Using `#!/bin/bash` ensures the script runs in the GNU Bash shell.

## 2. Making Scripts Executable

By default, newly created text files do not have execution permissions. To make a script executable, use `chmod`:
```bash
chmod +x script.sh
```

Once permissions are set, execute the script by specifying its path:
```bash
./script.sh
```

## 3. Strict Execution Mode (`set -e`, `set -u`, `set -o pipefail`)

By default, Bash will continue running a script even if a command fails. To write safer, robust scripts, enable strict options near the top:

```bash
#!/bin/bash
set -euo pipefail
```

- `set -e`: Exit immediately if any command returns a non-zero exit code.
- `set -u`: Treat unset variables as errors and exit immediately.
- `set -o pipefail`: Ensure pipelines return the exit code of the last command that failed.

Using strict mode prevents silent failures and helps catch bugs early.

---

## Lab Tasks

### Task 1: Create Your First Shell Script (`lnx-create-first-script`)
1. Start the lab:
   ```bash
   tld start lnx-create-first-script
   ```
2. Create an executable Bash script at `$HOME/script-test/hello.sh` starting with a valid shebang (`#!/bin/bash`).
3. Ensure the script prints `Hello, Shell!` to stdout when executed.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run Scripts Safely with Strict Options (`lnx-run-script-safely`)
1. Start the lab:
   ```bash
   tld start lnx-run-script-safely
   ```
2. Create an executable script at `$HOME/script-test/safe.sh` starting with shebang `#!/bin/bash`.
3. Enable strict execution mode by adding `set -euo pipefail` near the top of the script.
4. Ensure the script prints `Safe Execution` when executed.
5. Validate your solution:
   ```bash
   tld check
   ```
