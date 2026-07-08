## Recover a Broken Installation

Real-world DevOps engineering often involves walking into a server where someone has misconfigured Nginx, leaving the server down. In this section, you'll learn how to systematically debug and fix Nginx syntax errors.

---

## 1. Systematically Troubleshooting Nginx

If Nginx fails to start or reload:

1. **Test the configuration syntax**:
   ```bash
   sudo nginx -t
   ```
   This is the fastest way to find where the error is. Nginx will report the exact file name and line number of any syntax error.

2. **Check Systemd service logs**:
   ```bash
   sudo systemctl status nginx
   # Or view detailed logs with journalctl:
   sudo journalctl -u nginx --no-pager -n 20
   ```

3. **Check the error log file**:
   ```bash
   sudo tail -n 20 /var/log/nginx/error.log
   ```

---

## Lab Tasks

### Task 1: Fix the broken Nginx installation
1. Start the lab:
   ```bash
   tld start nginx-fix-installation
   ```
   This will intentionally introduce a syntax error in your default Nginx configuration file. Nginx will be stopped.
2. Troubleshoot and fix the error so Nginx can successfully pass the configuration check and start.
3. Verify the task:
   ```bash
   tld check
   ```
