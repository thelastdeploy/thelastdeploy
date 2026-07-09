## Custom Error Pages

When an error occurs (such as a 404 File Not Found or a 500 Internal Server Error), Nginx serves a default, generic HTML error page. To present a professional, branded interface, you can override these defaults using the `error_page` directive.

---

## 1. The `error_page` Directive

The `error_page` directive maps specific HTTP status codes to a local URI:

```nginx
server {
    listen 80;
    root /var/www/html;

    # Map 404 error code to /404.html
    error_page 404 /404.html;

    # Match /404.html location to define its behavior
    location = /404.html {
        internal; # prevents direct client requests to this URI
    }
}
```

- **`internal`**: A security directive ensuring the error page can *only* be loaded as an internal redirection (not queried directly by a browser typing `http://example.com/404.html`).

---

## 2. Grouping Errors

You can map multiple status codes to a single error page:

```nginx
error_page 500 502 503 504 /50x.html;
```

---

## Lab Tasks

### Task 1: Configure custom 404 page
1. Start the lab:
   ```bash
   tld start nginx-custom-404
   ```
2. Create an HTML file named `404.html` in the root folder `/var/www/html/` containing the text `Custom 404 - File Not Found`.
3. Configure the default server block `/etc/nginx/sites-available/default` to return `/404.html` for all `404` errors.
4. Reload Nginx configuration.
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Configure custom 500 error page
1. Start the lab:
   ```bash
   tld start nginx-custom-500
   ```
2. Create an HTML file named `50x.html` in the root folder `/var/www/html/` containing the text `Custom 50x - Server Error`.
3. Configure the default server block to serve `/50x.html` for codes `500`, `502`, `503`, and `504`.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
