## Repair a Static Site

Nginx runs worker processes under a specific unprivileged user account (typically `www-data` or `nginx`). If Nginx returns a `403 Forbidden` error when serving files, it often points to a directory path permissions problem rather than configuration errors.

---

## 1. File Permissions for Nginx

For Nginx to successfully serve a static file:
1. The Nginx worker user (`www-data`) **must** have read permission (`r`) on the file.
2. The user **must** have read (`r`) and execute (`x`) permissions on **every parent directory** leading down to that file (to traverse the path).

If any parent folder in `/var/www/html/` has its permissions restricted (e.g. `chmod 700 /var/www`), Nginx will fail to serve `/var/www/html/index.html` with a `403 Forbidden` error logged in `/var/log/nginx/error.log`.

---

## 2. Fixing Permissions

To ensure standard web folders can be traversed and read:
- Set directory permissions to `755`:
  ```bash
  sudo find /var/www -type d -exec chmod 755 {} +
  ```
- Set file permissions to `644`:
  ```bash
  sudo find /var/www -type f -exec chmod 644 {} +
  ```
- Set directory ownership to `www-data`:
  ```bash
  sudo chown -R www-data:www-data /var/www
  ```

---

## Lab Tasks

### Task 1: Repair blocked static page
1. Start the lab:
   ```bash
   tld start nginx-static-site-not-working
   ```
2. The seed script has modified directory permissions of the default web index directory `/var/www/html` to `000` (revoked all read/execute access), blocking Nginx from serving the page and causing `403 Forbidden` errors.
3. Diagnose the issue using `curl` and inspect file/directory permissions:
   ```bash
   curl -i http://localhost/
   ls -ld /var/www /var/www/html
   ```
4. Restore standard directory permissions (`755`) on `/var/www/html` so Nginx worker processes (`www-data`) can traverse and read the directory:
   ```bash
   sudo chmod 755 /var/www/html
   ```
5. Confirm that accessing `http://localhost/` returns `200 OK` with the welcome page content:
   ```bash
   curl -i http://localhost/
   ```
6. Verify your solution:
   ```bash
   tld check
   ```
