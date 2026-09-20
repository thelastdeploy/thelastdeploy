# Cron Environment and Execution Troubleshooting

The most common reason a script works manually in terminal but fails under `cron` is differences in the execution environment.

## 1. Minimal Cron Environment

Unlike interactive terminal logins (which load `~/.bashrc` and custom `PATH` definitions), `cron` runs with a stripped-down default environment:
- Minimal `PATH`: usually limited to `/usr/bin:/bin`.
- Missing working directory context: defaults to the user's home directory.
- No terminal (TTY) attached.

## 2. Common Fixes

### Always Use Absolute Paths
Instead of `backup.sh`, specify `/usr/local/bin/backup.sh`.

### Define `PATH` at Top of Crontab
```cron
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
SHELL=/bin/bash

0 2 * * * /usr/local/bin/backup.sh
```

### Change Working Directory
If your script relies on local relative files, change directory first:
```cron
0 2 * * * cd /var/www/app && ./deploy.sh
```
