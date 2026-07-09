## Debug Routing & Precedence Gotchas

A common routing pitfall in Nginx is the conflict between standard prefix match blocks and regular expression blocks.

---

## 1. The Precedence Gotcha

Consider this configuration:

```nginx
location /documents/ {
    root /var/www/docs;
}

location ~ \.pdf$ {
    root /var/www/pdf;
}
```

If a client requests `/documents/report.pdf`:
1. Nginx identifies `/documents/` as the longest matching prefix block.
2. However, Nginx continues scanning regular expressions and matches `~ \.pdf$`.
3. Consequently, Nginx processes the request under the regex block instead of the prefix block, looking for the file at `/var/www/pdf/documents/report.pdf` (which fails or serves the wrong file).

---

## 2. The Solution: `^~` Modifier

To prevent Nginx from evaluating regex blocks when a specific prefix block matches, use the `^~` modifier:

```nginx
# Non-regex prefix match. If matched, Nginx stops looking.
location ^~ /documents/ {
    root /var/www/docs;
}
```

---

## Lab Tasks

### Task 1: Fix overlapping regex and prefix blocks
1. Start the lab:
   ```bash
   tld start nginx-fix-routing
   ```
2. The seed script has created:
   - `/var/www/docs/documents/report.pdf` containing the text `docs report`.
   - `/var/www/pdf/documents/report.pdf` containing the text `pdf report`.
3. The default server configuration contains conflicting locations where the regex match `~ \.pdf$` overrides the standard `/documents/` prefix location, causing `/documents/report.pdf` to return `pdf report`.
4. Fix the configuration so that requests under `/documents/` (including PDF files) are processed by the `/documents/` block and return the correct file content (`docs report`).
5. Verify the task:
   ```bash
   tld check
   ```
