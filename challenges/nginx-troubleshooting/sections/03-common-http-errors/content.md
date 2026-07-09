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
2. Diagnose why visiting the root site returns a `403 Forbidden` error. (Hint: check permissions on `/var/www/html/index.html`).
3. Fix the permission issue so that Nginx can read the file.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Fix a 404 Not Found Error
1. Start the lab:
   ```bash
   tld start nginx-fix-404
   ```
2. Diagnose why requests to the root site return `404 Not Found`.
3. Locate the typo in the configuration `/etc/nginx/sites-available/default` and fix it.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Fix a 500 Internal Server Error (Rewrite Loop)
1. Start the lab:
   ```bash
   tld start nginx-fix-500
   ```
2. Inspect the configuration `/etc/nginx/sites-available/default` and look at the location `/loop` block causing a 500 Internal Server Error.
3. Remove the conflicting rewrite loop rules so that Nginx returns the static file at `/var/www/html/index.html` directly for `/loop` requests.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```

### Task 4: Fix a 502 Bad Gateway Error
1. Start the lab:
   ```bash
   tld start nginx-fix-502
   ```
2. Diagnose why accessing the location `/api` returns a `502 Bad Gateway` error.
3. Locate the port of the running Python mock backend (already started for you) and update `/etc/nginx/sites-available/default` to proxy to the correct port.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
