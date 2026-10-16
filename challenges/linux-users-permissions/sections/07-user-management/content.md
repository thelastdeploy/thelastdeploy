## User Management

Linux administrators frequently provision new accounts, organize them into security groups, and clean them up when users leave a project. These tasks require superuser privileges.

---

## 1. Creating and Deleting Users

- **useradd** / **adduser**: Provisions a new user account. On Debian/Ubuntu, `adduser` is an interactive Perl script wrapper that simplifies home directory and password setup. On RHEL/CentOS/Fedora, `useradd` is the standard binary.
  ```bash
  sudo useradd newuser
  ```
- **userdel**: Removes a user account.
  ```bash
  # Delete user but keep home directory
  sudo userdel olduser
  
  # Delete user and recursively remove their home directory (-r)
  sudo userdel -r olduser
  ```

---

## 2. Managing Groups

- **groupadd**: Creates a new group.
  ```bash
  sudo groupadd developers
  ```
- **groupdel**: Deletes an existing group.
  ```bash
  sudo groupdel developers
  ```

---

## 3. Modifying User Groups (`usermod`)

To add an existing user to secondary groups, use `usermod` with the append (`-a`) and group (`-G`) options:
```bash
sudo usermod -aG developers bob
```
> [!WARNING]
> Always use the `-a` (append) flag with `-G`. If you omit `-a`, the user will be removed from all secondary groups not listed in the command!

---

## Lab Tasks

### Task 1: Create a system group
1. Start the lab in your terminal:
   ```bash
   tld start lnx-create-group
   ```
2. Create a new user group named `dev-team` on your local system using `groupadd`.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Create a new system user
1. Start the lab in your terminal:
   ```bash
   tld start lnx-create-user
   ```
2. Create a new user account named `dev-intern` on your local system using `useradd`.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Add user to a group
1. Start the lab in your terminal:
   ```bash
   tld start lnx-add-user-group
   ```
2. Assign the user `dev-intern` as a member of the secondary group `dev-team` using `usermod -aG`.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 4: Remove a system user
1. Start the lab in your terminal:
   ```bash
   tld start lnx-remove-user
   ```
2. Clean up the system by deleting the user account `dev-intern` using `userdel`.
3. Verify the task:
   ```bash
   tld check
   ```
