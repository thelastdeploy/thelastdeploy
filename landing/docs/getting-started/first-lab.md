---
title: "First Lab Walkthrough"
description: "Step-by-step walkthrough of starting, troubleshooting, and validating the File Permissions lab."
section: "Getting Started"
---

This walkthrough demonstrates how to complete the **Fix File Permissions (`lnx-file-permissions`)** lab challenge using standard terminal commands and `tld check`.

## 1. Start the Lab Environment

Run `tld lab start lnx-file-permissions` to provision the workspace:

```bash
tld lab start lnx-file-permissions
```

Output:

```text
==> Provisioning lab lnx-file-permissions...
✓ Lab directory created: ~/.tld/labs/current/workspace

SCENARIO:
A background deployment script `/workspace/deploy.sh` is failing during execution with a 'Permission denied' error.
Fix the permissions so the script can execute.
```

## 2. Inspect the Broken System

Change into the active workspace directory:

```bash
cd ~/.tld/labs/current/workspace
```

List file details using `ls -la`:

```bash
ls -la deploy.sh
```

Output:

```text
-rw-r--r-- 1 fsociety fsociety 84 Oct 6 12:00 deploy.sh
```

Attempting to run `./deploy.sh` returns a permission denied error:

```bash
./deploy.sh
# bash: ./deploy.sh: Permission denied
```

Notice that `deploy.sh` has read and write permissions (`-rw-r--r--`), but lacks the executable bit (`x`).

## 3. Apply the Fix

Add executable permissions to `deploy.sh` using `chmod`:

```bash
chmod +x deploy.sh
```

Verify that the permissions now show `-rwxr-xr-x`:

```bash
ls -la deploy.sh
```

## 4. Run `tld check`

Validate your fix by running `tld check`:

```bash
tld check
```

Output:

```text
==> Running Validator for lnx-file-permissions...
[✓] CHECK_FILE_EXISTS: deploy.sh is present.
[✓] CHECK_EXEC_PERM: deploy.sh has executable mode (+x).
[✓] CHECK_EXECUTION: deploy.sh executed with status 0.

==================================================
Lab completed! +15 XP awarded.
==================================================
```

`tld check` executes `~/.tld/labs/current/validator.sh`. Because all three assertions returned 0 exit status, the CLI credits your account with 15 XP.