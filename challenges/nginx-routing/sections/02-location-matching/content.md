## Location Matching & Precedence

Nginx matches request URIs using a strict order of precedence. When multiple location blocks match a request, Nginx selects the one with the highest priority, rather than the one declared first in the configuration file.

---

## 1. Matching Modifiers

- **`=` (Exact Match)**: Matches the URI exactly. High priority. If matched, Nginx stops searching.
  ```nginx
  location = /special { ... }
  ```
- **`^~` (Non-Regex Prefix Match)**: Matches prefix patterns. If this is the longest prefix match, Nginx skips checking regex blocks.
  ```nginx
  location ^~ /static/ { ... }
  ```
- **`~` (Case-Sensitive Regex Match)**: Matches case-sensitive regular expressions.
  ```nginx
  location ~ \.PNG$ { ... }
  ```
- **`~*` (Case-Insensitive Regex Match)**: Matches case-insensitive regular expressions.
  ```nginx
  location ~* \.(jpg|jpeg|png|gif)$ { ... }
  ```
- **No Modifier (Prefix Match)**: Standard prefix matching. Low priority.
  ```nginx
  location /docs/ { ... }
  ```

---

## 2. Order of Precedence

When a request arrives, Nginx resolves it as follows:

1. **Exact Matches (`=`)**: Checks for exact match. If found, Nginx terminates search immediately.
2. **Longest Prefix Match**: Checks all prefix blocks (no modifier and `^~`).
   - If the longest prefix match contains `^~`, Nginx terminates search immediately.
   - Otherwise, Nginx remembers this match and continues.
3. **Regular Expressions (`~` and `~*`)**: Checks regular expression blocks in the order they are defined in the configuration file. The **first** matching regex wins. If found, Nginx terminates search.
4. **Fallback**: If no regex matches, Nginx falls back to the remembered longest prefix match.

---

## Lab Tasks

### Task 1: Prefix matching
1. Start the lab:
   ```bash
   tld start nginx-prefix-match
   ```
2. The seed script has created `/var/www/docs/index.html` with content `prefix test`.
3. Configure a prefix location block `/docs` inside `/etc/nginx/sites-available/default` so that requests to `/docs` or `/docs/` serve content from `/var/www/docs` (using `root /var/www;` or `alias /var/www/docs/;`).
4. Validate the configuration and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Confirm that accessing `http://localhost/docs/` returns `prefix test`:
   ```bash
   curl -s http://localhost/docs/
   ```
6. Verify your solution:
   ```bash
   tld check
   ```

### Task 2: Exact matching
1. Start the lab:
   ```bash
   tld start nginx-exact-match
   ```
2. The seed script has created `/var/www/html/special.html` with content `exact test`.
3. Configure an exact location match `/special.html` using the `=` modifier inside `/etc/nginx/sites-available/default` to serve the file `/var/www/html/special.html`.
4. Validate the configuration and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Confirm that accessing `http://localhost/special.html` returns `exact test`:
   ```bash
   curl -s http://localhost/special.html
   ```
6. Verify your solution:
   ```bash
   tld check
   ```

### Task 3: Regex matching
1. Start the lab:
   ```bash
   tld start nginx-regex-match
   ```
2. The seed script has created `/var/www/html/test.PNG` with content `regex test`.
3. Configure a case-insensitive regex location matching image files ending in `.jpg`, `.jpeg`, `.png`, or `.gif` using the `~*` modifier inside `/etc/nginx/sites-available/default` (with `root /var/www/html;`).
4. Validate the configuration and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Confirm that accessing `http://localhost/test.PNG` returns `regex test`:
   ```bash
   curl -s http://localhost/test.PNG
   ```
6. Verify your solution:
   ```bash
   tld check
   ```
