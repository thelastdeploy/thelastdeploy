## Common HTTP Errors

When troubleshooting website issues, the HTTP status code returned to the client is the first clue.

---

## 1. 403 Forbidden
The client does not have permission to access the requested resource.
- **Common causes**:
  - Missing index file (e.g. `index.html`) when directory listing is disabled.
  - Incorrect file/directory permissions (e.g. Nginx worker process `www-data` cannot read the files or traverse the directory tree).
- **Resolution**:
  - Check directory permissions: ensure files are readable by `www-data` and directories are readable and executable (e.g. `chmod 755`).

---

## 2. 404 Not Found
The server cannot find the requested resource.
- **Common causes**:
  - Typo in the resource path or request URL.
  - Typo in the `root` or `alias` directive path in the configuration.
- **Resolution**:
  - Double check the document root path and ensure the file exists at the exact resolved path.

---

## 3. 500 Internal Server Error
A generic error message when the server encounters an unexpected condition.
- **Common causes**:
  - Configuration logic loops (e.g., recursive internal rewrites).
- **Resolution**:
  - Look at `/var/log/nginx/error.log` to find details of the rewrite loop and break the recursion.

---

## 4. 502 Bad Gateway
Nginx, acting as a gateway or proxy, received an invalid response from the upstream server.
- **Common causes**:
  - Upstream backend service (Node, Python, PHP-FPM) is offline/stopped.
  - Nginx is attempting to connect to the wrong port or socket file.
- **Resolution**:
  - Check if the backend process is running: `sudo systemctl status backend` or checking active listening ports.
  - Verify that the `proxy_pass` directive points to the correct port.

---

## Lab Tasks

### Task 1: Fix a 403 Forbidden Error
1. Start the lab:
   ```bash
   tld start nginx-fix-403
   ```
2. Inspect the permissions of `/var/www/html/index.html`:
   ```bash
   ls -la /var/www/html/index.html
   ```
3. Fix the permissions so that the Nginx worker process can read the file (e.g., grant world read permission `chmod 644` or `chmod +r`).
4. Verify HTTP 200 response:
   ```bash
   curl -I http://localhost/
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Fix a 404 Not Found Error
1. Start the lab:
   ```bash
   tld start nginx-fix-404
   ```
2. Inspect the root directive in `/etc/nginx/sites-available/default`:
   ```bash
   grep -n "root" /etc/nginx/sites-available/default
   ```
3. Correct the misspelled document root path from `/var/www/htm` to `/var/www/html;`.
4. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 3: Fix a 500 Internal Server Error (Rewrite Loop)
1. Start the lab:
   ```bash
   tld start nginx-fix-500
   ```
2. Inspect the `/loop` location block inside `/etc/nginx/sites-available/default` and observe the circular rewrite rules.
3. Remove the conflicting rewrite rules inside the `location /loop` block and configure it to serve `/index.html` (for example, using `try_files /index.html =404;`).
4. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 4: Fix a 502 Bad Gateway Error
1. Start the lab:
   ```bash
   tld start nginx-fix-502
   ```
2. Check the active listening port of the background backend service:
   ```bash
   sudo ss -tulpn | grep python
   ```
3. In `/etc/nginx/sites-available/default`, locate the `location /api` block and update `proxy_pass` from port `9090` to the actual backend address `http://127.0.0.1:8080;`.
4. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Check your solution:
   ```bash
   tld check
   ```
