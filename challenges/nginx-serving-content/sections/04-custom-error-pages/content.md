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
1. Start the lab in your terminal:
   ```bash
   tld start nginx-custom-404
   ```
2. Create `/var/www/html/404.html` containing `Custom 404 - File Not Found`:
   ```bash
   echo 'Custom 404 - File Not Found' | sudo tee /var/www/html/404.html
   ```
3. Add the `error_page 404 /404.html;` directive inside the default server block in `/etc/nginx/sites-available/default`:
   ```bash
   sudo sed -i '/server_name _;/a \    error_page 404 /404.html;' /etc/nginx/sites-available/default
   ```
4. Test configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t && sudo systemctl reload nginx
   ```
5. Confirm by testing a non-existent path:
   ```bash
   curl -i http://localhost/doesnotexist
   ```
6. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Configure custom 500 error page
1. Start the lab in your terminal:
   ```bash
   tld start nginx-custom-500
   ```
2. Create `/var/www/html/50x.html` containing `Custom 50x - Server Error`:
   ```bash
   echo 'Custom 50x - Server Error' | sudo tee /var/www/html/50x.html
   ```
3. Configure the default server block in `/etc/nginx/sites-available/default` to map status codes 500, 502, 503, and 504 to `/50x.html`:
   ```bash
   sudo sed -i '/server_name _;/a \    error_page 500 502 503 504 /50x.html;' /etc/nginx/sites-available/default
   ```
4. Test configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t && sudo systemctl reload nginx
   ```
5. Verify the task:
   ```bash
   tld check
   ```
