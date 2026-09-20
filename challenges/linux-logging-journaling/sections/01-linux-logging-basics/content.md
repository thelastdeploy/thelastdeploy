# Linux Logging Basics

In Linux, logs store chronologically ordered records of system events, user authentications, kernel operations, and application status updates.

## 1. The `/var/log/` Hierarchy

Linux centralizes system log files under the `/var/log/` directory:

- `/var/log/syslog` (or `messages`): General system-wide message logs.
- `/var/log/auth.log` (or `secure`): User authentication and authorization attempts (SSH logins, `sudo` usage).
- `/var/log/kern.log`: Kernel messages and hardware diagnostic events.
- `/var/log/dmesg`: Kernel ring buffer boot log messages.

## 2. Application Logs

Third-party applications and web servers maintain dedicated subdirectories inside `/var/log/`:
- `/var/log/nginx/access.log` and `error.log`: Nginx HTTP server events.
- `/var/log/mysql/`: Database engine query and error logs.

## 3. Real-Time Log Monitoring

To follow new entries in real-time as they are written:
```bash
tail -f /var/log/syslog
```
