## Location Blocks

Nginx delegates request handling using the `location` directive. Location blocks reside inside `server` blocks and define how specific request URIs are matched and routed.

---

## 1. Syntax of Location Blocks

The general syntax of a location block is:

```nginx
location [modifier] URI {
    # Directives to handle requests
}
```

- **`modifier`**: An optional character that changes how Nginx matches the URI (e.g. `=`, `^~`, `~`, `~*`).
- **`URI`**: The pattern matching the incoming request URI.

---

## 2. Basic Location Block

Without modifiers, a location block is treated as a **prefix match**:

```nginx
location /api/ {
    # Matches any request starting with /api/
}
```

Prefix matches are greedy: `/api/` matches `/api/users`, `/api/products/details`, etc.

---

## Complete the Section

Once you understand the basic location block syntax, move to the next section to study the exact matching mechanics and order of precedence.
