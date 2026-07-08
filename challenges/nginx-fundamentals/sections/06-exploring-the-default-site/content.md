## Exploring the Default Site

Nginx comes pre-configured with a default website. In this section, you'll learn where the default configuration resides and how Nginx serves static HTML files.

---

## 1. The Default Server Block

Nginx defines virtual hosts (websites) in server blocks. The default site is defined in:
- **/etc/nginx/sites-available/default**

This file contains a server block listening on port 80:
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Key directives explained:
- **`listen 80 default_server`**: Tells Nginx to serve requests on port 80 using this block if no other block matches the request's hostname.
- **`root /var/www/html`**: The directory on disk where Nginx looks for files to serve.
- **`index`**: The order of files Nginx will look for when a directory is requested (e.g. `/` will serve `/index.html`).
- **`server_name _`**: A wildcard hostname fallback.
- **`location /`**: Matches all request paths and serves files from the `root` directory, returning a `404` error if they are not found.

---

## Lab Tasks

### Task 1: View and modify the default welcome page
1. Start the lab:
   ```bash
   tld start nginx-default-page
   ```
2. Modify the default welcome HTML page served by Nginx (typically at `/var/www/html/index.html`) so that it contains the text `Hello from The Last Deploy` inside an `<h1>` tag.
3. Verify the task:
   ```bash
   tld check
   ```
