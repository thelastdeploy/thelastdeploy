# Foundation Mastery

Demonstrate complete mastery of fundamental Linux file management, user/group permissions, environment variables, and process lifecycle supervision.

Foundation mastery tests your core command-line dexterity: file manipulation, ownership, special permission bits (SUID, SGID, Sticky bit), symbolic/hard links, text filtering, and signal handling.

### Foundation Competencies
- **Permissions**: `chmod u+s,g+s`, ACL management (`setfacl`, `getfacl`).
- **Text & Process Filtering**: `awk`, `sed`, `grep -P`, `ps -ef`, `kill -9`.


---

## Lab Tasks

### Task 1: Master Linux System Basics (`lnx-master-linux-system-basics`)
1. Start the lab:
   ```bash
   tld start lnx-master-linux-system-basics
   ```
2. Create directory `$HOME/mastery-foundation`.
3. Execute file, environment, and process manipulations as required.
4. Write `FOUNDATION_SYSTEM_BASICS_MASTERED` into `$HOME/mastery-foundation/basics_mastery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Master Users, Files, and Processes (`lnx-master-users-files-and-processes`)
1. Start the lab:
   ```bash
   tld start lnx-master-users-files-and-processes
   ```
2. Configure user/group memberships, ACL permissions, and nice/renice process priorities.
3. Write `USERS_FILES_AND_PROCESSES_MASTERED` into `$HOME/mastery-foundation/access_process_mastery.log`.
4. Validate your solution:
   ```bash
   tld check
   ```
