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
