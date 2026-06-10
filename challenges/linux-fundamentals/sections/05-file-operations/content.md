## File Operations

Managing files and directories is a core skill for any Linux user. The shell provides standard tools to create, copy, move, rename, and delete files.

---

## 1. Creating Files and Folders

- **touch**: Create an empty file or update its modification time.
  ```bash
  touch index.html
  ```
- **mkdir**: Create a new directory.
  ```bash
  mkdir projects
  # Create nested directory structures (-p creates parent folders as needed)
  mkdir -p projects/web-app/src
  ```

---

## 2. Copying Files and Folders (`cp`)

Copying files takes a source path and a destination path:

- **Copy a file**: `cp config.json config.json.bak`
- **Copy a folder recursively**: `cp -r src/ backup/`

---

## 3. Moving and Renaming (`mv`)

The `mv` command is used for both moving files to different directories and renaming them:

- **Rename a file**: `mv oldname.txt newname.txt`
- **Move a file**: `mv file.txt /tmp/`

---

## 4. Deleting Files and Folders (`rm`)

- **Remove a file**: `rm file.txt`
- **Remove an empty folder**: `rmdir empty-folder/`
- **Remove a folder and its contents recursively and forcibly**: `rm -rf projects/`

> [!WARNING]
> `rm` does not have a recycle bin. Deleted files are permanently gone! Be extremely careful when running `rm -rf`.

---

## Lab Tasks

### Task 1: Create nested files and directories
1. Start the lab in your terminal:
   ```bash
   tld start lnx-create-files
   ```
2. Create a directory named `files-test` in your home directory, and touch a file named `newfile.txt` inside it.
3. Write the exact text `created` inside `newfile.txt`:
   ```bash
   mkdir -p ~/files-test
   echo "created" > ~/files-test/newfile.txt
   ```
4. Verify the task to earn your XP:
   ```bash
   tld check
   ```

### Task 2: Copy files in a directory
1. Start the lab in your terminal:
   ```bash
   tld start lnx-copy-files
   ```
2. The setup script created `~/files-test/source.txt`. Copy it to a new file named `destination.txt` in the same directory:
   ```bash
   cp ~/files-test/source.txt ~/files-test/destination.txt
   ```
3. Verify the task to earn your XP:
   ```bash
   tld check
   ```

### Task 3: Move or rename files
1. Start the lab in your terminal:
   ```bash
   tld start lnx-move-files
   ```
2. The setup script created `~/files-test/move-me.txt`. Rename/move it to a new file named `moved.txt` in the same directory:
   ```bash
   mv ~/files-test/move-me.txt ~/files-test/moved.txt
   ```
3. Verify the task:
   ```bash
   tld check
   ```

### Task 4: Delete files using rm
1. Start the lab in your terminal:
   ```bash
   tld start lnx-delete-files
   ```
2. Delete the file named `delete-me.txt` inside `~/files-test`:
   ```bash
   rm ~/files-test/delete-me.txt
   ```
3. Verify the task:
   ```bash
   tld check
   ```
