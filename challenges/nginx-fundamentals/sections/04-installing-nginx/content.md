## Installing Nginx

In this section, you'll learn how to install the Nginx web server on your system and verify its default installation configuration.

---

## 1. Installing via Package Manager

On Debian/Ubuntu systems, Nginx is available in the official repositories and can be installed using `apt`:

```bash
sudo apt update
sudo apt install nginx -y
```

Once installed, the package manager automatically configures Nginx as a systemd service, starts it, and configures it to run on boot.

---

## 2. File and Directory Layout

After installation, Nginx sets up a standard directory structure:
- **/etc/nginx/**: The primary configuration directory. Contains `nginx.conf` and subdirectories like `sites-available/` and `sites-enabled/`.
- **/var/www/html/**: The default document root where web files (such as the default index.html page) are served from.
- **/var/log/nginx/**: The directory where logs are kept, specifically `access.log` (logs all requests) and `error.log` (logs server errors and debug info).

---

## Lab Tasks

### Task 1: Install Nginx Web Server
1. Start the lab in your terminal:
   ```bash
   tld start nginx-install-server
   ```
2. Install the `nginx` package on your local system if it is not already installed (you can use your package manager, e.g. `apt` or `brew`, or configure it appropriately).
3. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Verify Nginx Installation
1. Start the lab in your terminal:
   ```bash
   tld start nginx-verify-installation
   ```
2. Verify that the default Nginx service files exist and Nginx can be located on the system path.
3. Verify the task:
   ```bash
   tld check
   ```
