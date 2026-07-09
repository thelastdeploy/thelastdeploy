## Root vs Alias

When mapping a location block to a system folder path, Nginx provides two directives: `root` and `alias`. Understanding the difference between them is vital to avoid incorrect path mapping.

---

## 1. The `root` Directive

The `root` directive appends the **entire location path** to the specified root directory.

```nginx
location /images/ {
    root /var/www/static;
}
```

When a request for `/images/photo.jpg` arrives:
- Nginx appends the URI `/images/photo.jpg` to `/var/www/static`.
- The resolved file path is: `/var/www/static/images/photo.jpg`.

---

## 2. The `alias` Directive

The `alias` directive replaces the **location path match** with the alias path.

```nginx
location /assets/ {
    alias /var/www/static/media/;
}
```

When a request for `/assets/photo.jpg` arrives:
- Nginx replaces `/assets/` with `/var/www/static/media/`.
- The resolved file path is: `/var/www/static/media/photo.jpg`.

> [!WARNING]
> When using `alias` inside a location block matching a trailing slash, the alias path **must** also end with a trailing slash to prevent directory path traversal glitches.

---

## Lab Tasks

### Task 1: Use the root directive
1. Start the lab:
   ```bash
   tld start nginx-root-directive
   ```
2. Configure a location block `/images/` inside `/etc/nginx/sites-available/default` using the `root` directive to serve files from `/var/www/static`.
3. Reload Nginx configuration.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Use the alias directive
1. Start the lab:
   ```bash
   tld start nginx-alias-directive
   ```
2. Configure a location block `/assets/` inside `/etc/nginx/sites-available/default` using the `alias` directive to serve files from `/var/www/static/media/`.
3. Reload Nginx configuration.
4. Verify the task:
   ```bash
   tld check
   ```
