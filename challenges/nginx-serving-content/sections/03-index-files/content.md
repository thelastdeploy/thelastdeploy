## Index Files

When a client requests a directory URI (e.g. `http://example.com/` ending in a trailing slash) instead of a specific file, Nginx checks for the presence of index files as defined by the `index` directive.

---

## 1. The `index` Directive

The `index` directive specifies the files that Nginx should look for in the requested directory.

```nginx
server {
    listen 80;
    root /var/www/html;
    index index.html index.htm;
}
```

Nginx processes this list from left to right:
1. It looks for `/var/www/html/index.html`. If found, it serves it.
2. If not found, it looks for `/var/www/html/index.htm`. If found, it serves it.
3. If neither exists, Nginx returns a `403 Forbidden` error (or attempts directory listing, as we'll see in section 5).

---

## 2. Dynamic Priority Customization

You can place the `index` directive in a specific `location` block to prioritize different files for subdirectories:

```nginx
location /blog/ {
    index index.php index.html;
}
```

---

## Lab Tasks

### Task 1: Set up a custom index priority
1. Start the lab in your terminal:
   ```bash
   tld start nginx-custom-index
   ```
   A pre-seeded file `/var/www/html/custom.html` has been created containing the string `Custom welcome page`.
2. Inspect `/etc/nginx/sites-available/default` to locate the current `index` directive:
   ```bash
   grep -n "index " /etc/nginx/sites-available/default
   ```
3. Update the `index` directive so that `custom.html` appears first in the list:
   ```bash
   sudo sed -i 's/index index.html/index custom.html index.html/' /etc/nginx/sites-available/default
   ```
4. Test configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t && sudo systemctl reload nginx
   ```
5. Confirm that querying the server root serves `custom.html`:
   ```bash
   curl -s http://localhost/
   ```
6. Verify the task:
   ```bash
   tld check
   ```
