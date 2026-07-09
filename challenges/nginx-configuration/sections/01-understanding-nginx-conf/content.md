## Understanding nginx.conf

Nginx is configured using a plain text file, typically named `nginx.conf` and located in `/etc/nginx/nginx.conf`. This configuration file determines how the web server functions, what ports it listens on, and how requests are processed.

---

## 1. Structure of nginx.conf

At first glance, `nginx.conf` can look complex. However, it is structured logically around simple rules. 

A standard installation includes a base configuration file that defines global settings and includes other context-specific files:

- **Comments**: Any line starting with a `#` character is treated as a comment and is ignored by the Nginx parser.
- **Semicolons**: Every simple configuration directive **must** end with a semicolon `;`. Missing semicolons are the most common source of Nginx configuration errors.
- **Curly Braces**: Block directives use curly braces `{}` to group nested configurations (e.g., `events {}`, `http {}`).

---

## 2. Default Configuration Template

Here is a simplified example of a standard `/etc/nginx/nginx.conf` file:

```nginx
user nginx;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

In the next sections, we will explore what these blocks (contexts) and settings (directives) mean and how they inherit configurations from each other.

---

## Complete the Section

Once you understand the basic file structure, move to the next section to study Contexts and Directives in depth.
