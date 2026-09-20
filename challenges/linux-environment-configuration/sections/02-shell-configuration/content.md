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
