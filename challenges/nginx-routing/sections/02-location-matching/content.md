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
2. Configure a prefix location block matching `/docs` to serve content from `/var/www/docs`.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Exact matching
1. Start the lab:
   ```bash
   tld start nginx-exact-match
   ```
2. Configure an exact location match `/special.html` using the `=` modifier to serve the file `/var/www/html/special.html`.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Regex matching
1. Start the lab:
   ```bash
   tld start nginx-regex-match
   ```
2. Configure a case-insensitive regex match location matching image files ending in `.jpg`, `.jpeg`, `.png`, or `.gif` using the `~*` modifier. Serve them from root `/var/www/html`.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```
