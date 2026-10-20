## Recover a Production Nginx Server

During a production outage, you may encounter multiple stacked issues (e.g. syntax errors, port conflicts, and backend service crashes) simultaneously. Systematically resolving them one by one is key to recovering the service.

---

## 1. Handling Combined Outage Scenarios

When Nginx fails to boot:
1. Run `nginx -t` to identify and fix the first syntax error (e.g. missing semicolons, unmatched curly braces).
2. Run `nginx -t` again to identify downstream syntax errors or conflicts (e.g. duplicate default servers listening on port 80).
3. Start the Nginx service. If it fails, inspect the system logs (`journalctl -u nginx` or `/var/log/nginx/error.log`) to check for port conflicts or permission blocks.

---

## Lab Tasks

### Task 1: Recover a Broken Production Nginx Server
1. Start the lab:
   ```bash
   tld start nginx-production-outage
   ```
2. Diagnose configuration issues iteratively using `nginx -t`:
   ```bash
   sudo nginx -t
   ```
3. Locate and fix the three configuration issues:
   - Add the missing semicolon to the `keepalive_timeout 65` directive in `/etc/nginx/nginx.conf`.
   - In `/etc/nginx/sites-available/default`, fix the invalid proxy scheme in the `/outage` location (`ht://` -> `http://`).
   - In `/etc/nginx/sites-available/default`, resolve the duplicate `default_server` conflict (ensure only one server block is designated as `default_server`).
4. Validate configuration syntax:
   ```bash
   sudo nginx -t
   ```
5. Start the Nginx service and verify its active status:
   ```bash
   sudo systemctl start nginx
   sudo systemctl status nginx
   ```
6. Check your solution:
   ```bash
   tld check
   ```
