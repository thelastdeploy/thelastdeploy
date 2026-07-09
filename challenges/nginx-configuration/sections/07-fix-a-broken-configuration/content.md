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
1. Start the lab:
   ```bash
   tld start nginx-debug-config
   ```
2. The seed script has created a duplicate server block file `/etc/nginx/sites-available/duplicate-default` and enabled it by creating a symbolic link in `/etc/nginx/sites-enabled/`. This causes Nginx to fail starting due to conflicting `default_server` directives on port 80.
3. Locate the duplicate file and fix the configuration so Nginx can start successfully.
4. Verify the task:
   ```bash
   tld check
   ```
