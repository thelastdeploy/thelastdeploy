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
1. Start the lab in your terminal:
   ```bash
   tld start nginx-include-config
   ```
2. Inspect the pre-seeded snippet containing custom headers:
   ```bash
   cat /etc/nginx/snippets/custom-headers.conf
   ```
3. Include this snippet inside the default server block in `/etc/nginx/sites-available/default`:
   ```bash
   sudo sed -i '/server_name _;/a \    include /etc/nginx/snippets/custom-headers.conf;' /etc/nginx/sites-available/default
   ```
4. Verify the syntax of your configuration:
   ```bash
   sudo nginx -t
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Organize configuration files
1. Start the lab in your terminal:
   ```bash
   tld start nginx-organize-configs
   ```
2. Create a new modular configuration file at `/etc/nginx/conf.d/upstream.conf`:
   ```bash
   sudo tee /etc/nginx/conf.d/upstream.conf << 'EOF'
   upstream myapp {
       server 127.0.0.1:9000;
   }
   EOF
   ```
3. Validate the configuration syntax:
   ```bash
   sudo nginx -t
   ```
4. Verify the task:
   ```bash
   tld check
   ```
