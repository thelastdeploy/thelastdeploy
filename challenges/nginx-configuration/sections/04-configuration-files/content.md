## Configuration Files & modularity

To keep configs readable and manageable, Nginx supports importing configuration files from outside `nginx.conf` using the `include` directive.

---

## 1. The `include` Directive

The `include` directive inserts the contents of another configuration file or matches wildcard paths. It can be placed in any context:

```nginx
http {
    # Include server blocks from separate files
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

You can also use it inside a `server` context to share common configuration snippets, such as standard proxy headers or SSL configurations:

```nginx
server {
    listen 80;
    server_name example.com;

    # Include custom SSL snippets
    include snippets/ssl-params.conf;
}
```

---

## 2. Default Configuration Directories

- **/etc/nginx/conf.d/**: Standard location for global web server modular configs. Files here must end in `.conf` to be loaded by default configurations.
- **/etc/nginx/snippets/**: Common snippets and parameter lists that can be included inside specific server or location blocks.

---

## Lab Tasks

### Task 1: Include a custom configuration snippet
1. Start the lab:
   ```bash
   tld start nginx-include-config
   ```
2. The seed script has created a snippet containing custom headers at `/etc/nginx/snippets/custom-headers.conf`.
3. Include this snippet inside the `http` block of `/etc/nginx/nginx.conf` (or inside the default server block in `/etc/nginx/sites-available/default`).
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Organize configuration files
1. Start the lab:
   ```bash
   tld start nginx-organize-configs
   ```
2. Create a new custom configuration file named `upstream.conf` under `/etc/nginx/conf.d/`.
3. Add a simple valid directive or block (for example, a comment or an empty upstream definition, e.g., `upstream myapp { server 127.0.0.1:9000; }`).
4. Ensure Nginx configuration check passes.
5. Verify the task:
   ```bash
   tld check
   ```
