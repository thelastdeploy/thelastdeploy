## Server Blocks (Virtual Hosts)

In Nginx, a **server block** defines a virtual host. This allows you to host multiple websites or APIs on a single physical server, distinguishing between them by port number or domain name (hostname).

---

## 1. Defining a Server Block

Server blocks reside inside the `http` block of `nginx.conf` (or are included via directories like `/etc/nginx/sites-enabled/`). Here is the anatomy of a basic server block:

```nginx
server {
    listen 8080;
    server_name mydomain.com www.mydomain.com;

    root /var/www/mydomain;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

- **`listen`**: Tells Nginx which IP and port to listen on. It can be a port number (e.g. `8080`), an IP address with port (`127.0.0.1:8080`), or a Unix domain socket path.
- **`server_name`**: Specifies hostnames (domains) this server block matches. Nginx matches the `Host` header of incoming HTTP requests against this list.
- **`root`**: The document directory on disk where Nginx looks for files to serve.
- **`index`**: The default files to search for when a directory path is requested.

---

## 2. sites-available vs sites-enabled

On Debian/Ubuntu systems, configurations are organized to make enabling/disabling sites simple:
1. **`sites-available/`**: Contains the full configuration files for all available server blocks.
2. **`sites-enabled/`**: Contains symbolic links (symlinks) pointing to files inside `sites-available/`. Nginx is configured to load *only* configurations in `sites-enabled/`.

To enable a site named `mysite`:
```bash
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/
```

To disable it:
```bash
sudo rm /etc/nginx/sites-enabled/mysite
```

---

## Lab Tasks

### Task 1: Create a server block configuration
1. Start the lab:
   ```bash
   tld start nginx-create-server-block
   ```
2. Create a server block configuration file named `mysite` under `/etc/nginx/sites-available/`.
3. Configure it to:
   - Listen on port `8080`.
   - Match hostname `mysite.local`.
   - Set the document root to `/var/www/mysite`.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Enable the server block configuration
1. Start the lab:
   ```bash
   tld start nginx-enable-server-block
   ```
2. Enable the server block by creating a symbolic link in `/etc/nginx/sites-enabled/` pointing to your `/etc/nginx/sites-available/mysite` configuration.
3. Verify the task:
   ```bash
   tld check
   ```
