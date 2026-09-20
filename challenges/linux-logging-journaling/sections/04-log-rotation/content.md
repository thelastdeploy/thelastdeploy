# Log Rotation and Compression

Log files left unmanaged will eventually consume all available disk space. Linux uses the `logrotate` utility to automatically archive, compress, rotate, and prune log files.

## 1. `logrotate` Configuration

Configurations are stored in `/etc/logrotate.conf` and modular rule files in `/etc/logrotate.d/`:

```logrotate
/var/log/app/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 appuser appgroup
}
```

- `daily`: Rotate log files once per day.
- `rotate 7`: Keep 7 rotated backlog files before deleting old ones.
- `compress`: Compress rotated files using `gzip` (`.gz`).
- `delaycompress`: Postpone compression of the most recent rotated file until the next rotation cycle.

## 2. Inspecting Compressed Logs (`zcat`, `zgrep`, `zless`)

Linux provides `z-utilities` to read gzip-compressed log archives directly without extracting them first:

```bash
# Search compressed log archives for errors
zgrep "ERROR" /var/log/syslog.2.gz

# View compressed log contents
zcat /var/log/nginx/access.log.3.gz | head -n 20
```
