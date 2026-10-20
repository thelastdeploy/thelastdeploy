## Testing Configurations

Before reloading or restarting Nginx, you should always test the configuration files to verify that they are free of syntax errors. If you reload a configuration with errors, Nginx will either fail to apply the changes or refuse to start.

---

## 1. Using `nginx -t`

The standard way to test configuration syntax is by running:

```bash
sudo nginx -t
```

This command parses all configuration files (starting with `nginx.conf`) and reports any errors found:
- If valid, it returns:
  ```text
  nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
  nginx: configuration file /etc/nginx/nginx.conf test is successful
  ```
- If invalid, it reports the exact file path and line number of the first error:
  ```text
  nginx: [emerg] invalid number of arguments in "listen" directive in /etc/nginx/sites-enabled/default:39
  nginx: configuration file /etc/nginx/nginx.conf test failed
  ```

---

## 2. Using `nginx -T` (Dump Configuration)

If you need to view the entire active configuration (including all included files and snippets) printed as a single output block, use the `-T` flag:

```bash
sudo nginx -T
```

This is particularly useful when debugging macro inclusions and verifying directive inheritance.

---

## Lab Tasks

### Task 1: Perform a configuration test
1. Start the lab in your terminal:
   ```bash
   tld start nginx-configtest
   ```
2. Test the active Nginx configuration and redirect both stdout and stderr into `/tmp/config_test_result.txt`:
   ```bash
   sudo nginx -t > /tmp/config_test_result.txt 2>&1
   ```
3. Inspect the recorded test output:
   ```bash
   cat /tmp/config_test_result.txt
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Find and fix configuration syntax error
1. Start the lab in your terminal:
   ```bash
   tld start nginx-find-config-error
   ```
   The default site configuration `/etc/nginx/sites-available/default` has a missing semicolon on a directive, causing configuration tests to fail.
2. Run the Nginx configuration test to locate the exact file and line number:
   ```bash
   sudo nginx -t
   ```
3. Edit `/etc/nginx/sites-available/default` to restore the missing semicolon on the `root` directive:
   ```bash
   sudo sed -i 's/root \/var\/www\/html$/root \/var\/www\/html;/' /etc/nginx/sites-available/default
   ```
4. Verify that the configuration test now passes cleanly:
   ```bash
   sudo nginx -t
   ```
5. Verify the task:
   ```bash
   tld check
   ```
