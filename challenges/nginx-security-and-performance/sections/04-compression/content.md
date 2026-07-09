## Gzip Compression

Enabling compression reduces the byte size of static file transfers (especially text assets like HTML, CSS, JSON, and JS) by up to 70%, resulting in faster page load times and reduced bandwidth costs.

Nginx handles this transparently using the `ngx_http_gzip_module`.

---

## 1. Configuring Gzip in Nginx

To enable Gzip, add the following directives to your `nginx.conf` inside the global `http` context:

```nginx
http {
    # Enable gzip compression
    gzip on;

    # Compresses data even for clients connecting via proxy
    gzip_proxied any;

    # Set compression level (1 to 9; 5 or 6 is the sweet spot between CPU and size)
    gzip_comp_level 6;

    # Minimum file size to compress (in bytes; small files are not worth the CPU overhead)
    gzip_min_length 256;

    # Specifying MIME-types to compress (Nginx compresses text/html by default)
    gzip_types
        text/plain
        text/css
        application/json
        application/javascript
        text/xml
        application/xml;
}
```

---

## Lab Tasks

### Task 1: Enable Gzip Compression
1. Start the lab:
   ```bash
   tld start nginx-enable-gzip
   ```
2. Enable Gzip compression globally in `/etc/nginx/nginx.conf` inside the `http` context.
3. Configure `gzip_types` to include `text/css` and `application/json`.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
