## Directory Behaviour & Listings

When a request resolves to a directory path instead of a file, Nginx needs to decide what to do if no matching index files exist. By default, it returns a `403 Forbidden` response. However, you can configure it to list the directory files using the `autoindex` module.

---

## 1. Directory Listing (`autoindex`)

The `autoindex` directive controls whether Nginx lists the contents of a directory when no index file (e.g. `index.html`) is present:

- **`autoindex off;`** (Default): Disables directory listings. Accessing the directory returns a `403 Forbidden` error. This is a security best practice for production sites.
- **`autoindex on;`**: Enables directory listings. Nginx dynamically generates an HTML index listing all files and folders in that directory. Useful for hosting software download repositories.

Example:
```nginx
location /downloads/ {
    root /var/www/static;
    autoindex on;
}
```

---

## Lab Tasks

### Task 1: Ensure directory listing is disabled
1. Start the lab:
   ```bash
   tld start nginx-disable-directory-listing
   ```
2. The seed script has provisioned an indexless directory `/var/www/html/secret/` containing private data files.
3. Ensure Nginx is running and verify that accessing `http://localhost/secret/` returns a `403 Forbidden` response rather than listing directory contents:
   ```bash
   curl -i http://localhost/secret/
   ```
4. Verify your solution:
   ```bash
   tld check
   ```

### Task 2: Enable directory listing for downloads
1. Start the lab:
   ```bash
   tld start nginx-enable-directory-listing
   ```
2. The seed script has provisioned `/var/www/html/downloads/` containing package archives (`pkg1.tar.gz`) without an `index.html` file.
3. Configure a `location /downloads/` block inside `/etc/nginx/sites-available/default` so that directory listing is explicitly enabled using the `autoindex` directive.
4. Validate the configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Confirm that accessing `http://localhost/downloads/` returns the directory listing containing `pkg1.tar.gz`:
   ```bash
   curl -s http://localhost/downloads/
   ```
6. Verify your solution:
   ```bash
   tld check
   ```
