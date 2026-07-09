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
2. The seed script has created an indexless directory `/var/www/html/secret/` containing private files.
3. Configure Nginx (or verify) to ensure that accessing `http://localhost/secret/` returns a `403 Forbidden` response rather than listing the files.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Enable directory listing for downloads
1. Start the lab:
   ```bash
   tld start nginx-enable-directory-listing
   ```
2. The seed script has created `/var/www/html/downloads/` with several package files but no index page.
3. Configure a location block `/downloads/` inside `/etc/nginx/sites-available/default` so that directory listing is enabled for it.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
