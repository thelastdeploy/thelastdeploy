# User Crontabs and Recurring Tasks

Users manage their personal scheduled tasks using the `crontab` command line utility.

## 1. Crontab Commands

- `crontab -l`: Display (list) the contents of your active crontab.
- `crontab -e`: Edit your active crontab in your default text editor.
- `crontab -r`: Remove your active crontab entirely.
- `crontab file.txt`: Install a crontab schedule directly from `file.txt`.

## 2. Output Redirection in Cron Jobs

Cron jobs execute in non-interactive shells. If standard output (stdout) or standard error (stderr) are produced without redirection, cron attempts to send an email to the user.

To append stdout and stderr to a log file:
```cron
0 * * * * /usr/local/bin/cleanup.sh >> /var/log/cleanup.log 2>&1
```

To suppress output completely:
```cron
0 * * * * /usr/local/bin/cleanup.sh > /dev/null 2>&1
```
