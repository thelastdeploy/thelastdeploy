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
2. The Nginx service is stopped, and the configurations are corrupted with multiple bugs.
3. Use `nginx -t` and the logs to diagnose and resolve:
   - A missing semicolon in `/etc/nginx/nginx.conf`.
   - A duplicate `default_server` directive in `/etc/nginx/sites-available/default` (remove it so only one server block has `default_server`).
   - An invalid `proxy_pass` scheme in `/etc/nginx/sites-available/default` (e.g. `proxy_pass ht://127.0.0.1:8080;` instead of `http://`).
4. Ensure Nginx configuration is valid, start the service, and verify it is running.
5. Verify the task:
   ```bash
   tld check
   ```
