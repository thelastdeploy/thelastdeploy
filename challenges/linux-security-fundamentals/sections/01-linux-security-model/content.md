# Linux Security Model

Linux uses a **Discretionary Access Control (DAC)** model to determine whether a process or user is authorized to perform an operation (read, write, execute) on a system resource.

## 1. User and Group Identifiers

Every process and file is bound to identity credentials:
- **UID (User ID)**: Unique numerical identifier for users (Root is 0).
- **GID (Group ID)**: Numerical identifier for primary and supplementary groups.

Inspect identity context:
```bash
# Print detailed user/group security context
id

# Print current username
whoami

# Print supplementary groups
groups
```

## 2. DAC Evaluation Precedence

When a process attempts to access a file, Linux checks permissions in a strict order:
1. **User Check**: If the process UID matches the file owner UID, the owner permission bits (`rwx------`) apply. Linux ignores group/other permissions.
2. **Group Check**: If the process belongs to the file's owning group, group permission bits (`---rwx---`) apply.
3. **Other Check**: If neither UID nor GID match, other permission bits (`------rwx`) apply.

---

## Lab Tasks

### Task 1: Inspect User Security Context and Group Memberships (`lnx-inspect-user-security-context`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-user-security-context
   ```
2. Inspect user security context, UID, GID, and group memberships.
3. Save user security context details to `$HOME/sec-test/user_context.txt` using `id`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Understand Effective Permission Evaluation (`lnx-understand-effective-permissions`)
1. Start the lab:
   ```bash
   tld start lnx-understand-effective-permissions
   ```
2. Evaluate read/write/execute permission evaluation rules.
3. Save the evaluation result (`ALLOWED` or `DENIED`) for test scenario permissions to `$HOME/sec-test/eval_result.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
