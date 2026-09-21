# Application Configuration Management

In Linux systems, application settings are traditionally stored in plaintext text files located in `/etc/` or user-specific config directories inside `~/.config/`.

## 1. Locating Configuration Files

- System-wide configs: `/etc/` (e.g. `/etc/nginx/nginx.conf`, `/etc/ssh/sshd_config`).
- User configs: `~/.config/` or dotfiles in `~` (e.g. `~/.gitconfig`).

Use `find` to locate configuration files:
```bash
find /etc -name "*.conf"
```

## 2. Inspecting Active Settings

Configuration files often contain extensive documentation comments starting with `#` or `;`. To filter out comments and empty lines to inspect active settings:

```bash
grep -v '^[[:space:]]*#' /etc/web.conf | grep -v '^[[:space:]]*$'
```

## 3. Safely Modifying Configurations

Always create a backup copy before making manual or scripted changes:

```bash
cp app.conf app.conf.bak
sed -i 's/PORT=8080/PORT=9090/' app.conf
```

---

## Lab Tasks

### Task 1: Locate System Configuration Files (`lnx-find-application-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-find-application-configuration
   ```
2. Locate system configuration files.
3. Create a file list at `$HOME/env-test/config_files.list` containing `nginx.conf` and `redis.conf`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Active Configuration Settings (`lnx-inspect-configuration-settings`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-configuration-settings
   ```
2. Filter out comments and blank lines from configuration files.
3. Extract active setting lines from `$HOME/env-test/service.conf` and write to `$HOME/env-test/active_settings.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Modify Configuration Settings and Preserve Backups (`lnx-modify-application-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-modify-application-configuration
   ```
2. Safely update configuration values while maintaining backups.
3. Create a backup at `$HOME/env-test/service.conf.bak` and update `MAX_CONNECTIONS=500` in `$HOME/env-test/service.conf`.
4. Validate your solution:
   ```bash
   tld check
   ```
