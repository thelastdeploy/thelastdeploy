## URI Rewriting

The `rewrite` directive modifies request URIs internally using regular expressions, directing Nginx to process the new URI without changing the URL shown in the client's browser.

---

## 1. The `rewrite` Directive Syntax

```nginx
rewrite regex replacement [flag];
```

- **`regex`**: A regular expression matching the original request URI. Capture groups can be referenced in the replacement as `$1`, `$2`, etc.
- **`replacement`**: The new URI path.
- **`flag`**: Optional flags modifying processing behavior:
  - **`last`**: Stops processing current rewrites and starts a new search for location blocks matching the new URI. (Default behavior inside `server` context).
  - **`break`**: Stops processing current rewrites and executes the directives under the *current* location block.
  - **`redirect`**: Returns a temporary redirect (status `302`) to the browser, changing the address bar.
  - **`permanent`**: Returns a permanent redirect (status `301`), changing the address bar.

---

## 2. Examples

- **Basic Internal Rewrite**:
  ```nginx
  rewrite ^/oldpath/file.html$ /newpath/file.html last;
  ```
- **Pretty URL Structure**:
  ```nginx
  # Rewrites /products/123 to /product.html?id=123
  rewrite ^/products/([0-9]+)$ /product.html?id=$1 last;
  ```

---

## Lab Tasks

### Task 1: Basic internal rewrite
1. Start the lab:
   ```bash
   tld start nginx-basic-rewrite
   ```
2. The seed script has created `/var/www/html/newpath/file.html` containing `new content`.
3. Configure a rewrite rule in the default server block to internally map requests from `/oldpath/file.html` to `/newpath/file.html`.
4. Verify that hitting `/oldpath/file.html` returns `new content` with a `200 OK` code (an internal rewrite rather than a browser redirection).
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Pretty URLs rewrite
1. Start the lab:
   ```bash
   tld start nginx-pretty-url
   ```
2. The seed script has created `/var/www/html/product.html` containing a script template.
3. Configure a rewrite rule mapping `/products/([0-9]+)` (where capture group 1 is a numeric product ID) internally to `/product.html?id=$1`.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
