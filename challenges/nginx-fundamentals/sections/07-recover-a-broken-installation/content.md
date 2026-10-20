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
1. Start the lab in your terminal:
   ```bash
   tld start nginx-fix-installation
   ```
   This environment contains an intentional syntax error in the default site configuration, preventing Nginx from starting.
2. Run the Nginx configuration test to identify the corrupted file and line number:
   ```bash
   sudo nginx -t
   ```
3. Inspect `/etc/nginx/sites-available/default` and remove the erroneous directive `broken_syntax_here`:
   ```bash
   sudo sed -i 's/ broken_syntax_here//g' /etc/nginx/sites-available/default
   ```
4. Re-test the configuration to ensure the syntax is valid:
   ```bash
   sudo nginx -t
   ```
5. Start the Nginx service and verify that it is active:
   ```bash
   sudo systemctl start nginx
   sudo systemctl status nginx
   ```
6. Verify the task:
   ```bash
   tld check
   ```
