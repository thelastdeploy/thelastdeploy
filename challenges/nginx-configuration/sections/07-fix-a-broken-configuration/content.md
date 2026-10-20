## Fix a Broken Configuration

A common Nginx startup failure is the "duplicate default server" error. In Nginx, only one server block per IP/Port combination can be designated as the `default_server`. If multiple blocks define it, Nginx will fail to start.

---

## 1. What causes "duplicate default server"?

If Nginx logs this error:
```text
nginx: [emerg] a duplicate default server for 0.0.0.0:80 in /etc/nginx/sites-enabled/mysite:3
```
It means you have configured `listen 80 default_server;` (or similar) in more than one enabled server block file.

---

## 2. Debugging Steps

1. Find all files declaring `default_server` inside `/etc/nginx/`:
   ```bash
   grep -r "default_server" /etc/nginx/
   ```
2. Identify the duplicate files that are currently active in `sites-enabled/`.
3. Edit the duplicate configurations to remove the `default_server` flag from the `listen` directive, or disable the duplicate file if it is not needed.
4. Verify using `sudo nginx -t`.

---

## Lab Tasks

### Task 1: Fix duplicate default server configuration
1. Start the lab in your terminal:
   ```bash
   tld start nginx-debug-config
   ```
   A duplicate server block `/etc/nginx/sites-available/duplicate-default` has been linked into `/etc/nginx/sites-enabled/duplicate-default`, causing conflicting `default_server` definitions on port 80.
2. Run `sudo nginx -t` to identify the conflicting directive:
   ```bash
   sudo nginx -t
   ```
3. Disable the duplicate site by unlinking it from `sites-enabled`:
   ```bash
   sudo rm /etc/nginx/sites-enabled/duplicate-default
   ```
4. Verify that the configuration syntax now passes:
   ```bash
   sudo nginx -t
   ```
5. Start the Nginx service:
   ```bash
   sudo systemctl start nginx
   sudo systemctl status nginx
   ```
6. Verify the task:
   ```bash
   tld check
   ```
