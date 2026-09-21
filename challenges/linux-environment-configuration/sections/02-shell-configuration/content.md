# Shell Startup & Initialization Files

When a Bash shell opens, it loads configuration files to set environment variables, PATH modifications, aliases, and prompts.

## 1. Startup Files Hierarchy

- **Login Shells** (SSH logins, terminal logins):
  Reads `/etc/profile` first, then the first readable file among `~/.bash_profile`, `~/.bash_login`, and `~/.profile`.
- **Non-Login Shells** (opening a new terminal window inside desktop GUI):
  Reads `/etc/bash.bashrc` and `~/.bashrc`.

## 2. Custom Shell Aliases and Exports

Aliases create shortcuts for long commands:

```bash
# Add to ~/.bashrc
alias ll='ls -la'
alias syslog='tail -f /var/log/syslog'

export PATH="$HOME/bin:$PATH"
```

## 3. Reloading Configuration (`source`)

To apply edits to `~/.bashrc` without logging out and back in:

```bash
source ~/.bashrc
# or shorthand dot operator
. ~/.bashrc
```

---

## Lab Tasks

### Task 1: Configure Shell Environment in Bashrc (`lnx-configure-shell-environment`)
1. Start the lab:
   ```bash
   tld start lnx-configure-shell-environment
   ```
2. Configure custom shell aliases and environment variables.
3. Create a mock bashrc file at `$HOME/env-test/mock_bashrc` containing `export LAB_ENV="devlab"` and `alias syscheck="uptime"`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Shell Startup Script Cascade (`lnx-manage-shell-startup`)
1. Start the lab:
   ```bash
   tld start lnx-manage-shell-startup
   ```
2. Manage shell startup file cascading.
3. Create a profile script at `$HOME/env-test/mock_profile` that sources `mock_bashrc` (`source $HOME/env-test/mock_bashrc`).
4. Validate your solution:
   ```bash
   tld check
   ```
