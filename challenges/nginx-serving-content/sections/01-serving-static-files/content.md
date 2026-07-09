## Serving Static Files

One of Nginx's primary use cases is serving static content (HTML, CSS, JavaScript, images, videos) efficiently. Unlike application servers, Nginx optimizes static requests at the kernel level.

---

## 1. Static Content Directives

To serve static files, Nginx maps request URIs to paths on the file system:

- **`root`**: Sets the base directory for requests.
- **`try_files`**: Checks for the existence of files in the specified order and falls back to a default URI if none are found.

```nginx
location / {
    root /var/www/html;
    try_files $uri $uri/ =404;
}
```

---

## 2. Kernel-Level Optimizations

To handle high traffic volume, Nginx includes directives that bypass standard user-space file reading:

- **`sendfile on;`**: Directs Nginx to copy data directly from one file descriptor to another at the kernel level, avoiding copy operations between kernel space and user space. This speeds up serving static media.
- **`tcp_nopush on;`**: Used alongside `sendfile`. It tells Nginx to send all header packets in a single TCP packet, optimizing network packet sizes.
- **`tcp_nodelay on;`**: Overrides Nagle's algorithm to immediately send small TCP packets, reducing latency for interactive connections.

---

## Complete the Section

Once you understand static optimization headers, move to the next section to compare the `root` and `alias` directives.
