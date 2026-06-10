## Navigation

Navigating the Linux filesystem is done using simple built-in shell tools. The commands `pwd` and `cd` form the bedrock of navigation.

---

## 1. Print Working Directory (`pwd`)

To see exactly where you are in the filesystem tree, run `pwd`. This command returns the absolute path of your current directory.

```bash
pwd
# Outputs: /home/fsociety
```

---

## 2. Change Directory (`cd`)

To move to a different directory, use `cd` followed by the directory path.

- **Move into a directory**: `cd documents`
- **Move to your user's Home directory**: `cd` or `cd ~`
- **Move to the parent folder**: `cd ..`
- **Move to the root of the filesystem**: `cd /`

---

## 3. Dot References

- `.`: Represents the current directory.
- `..`: Represents the parent directory.

---

## Lab Tasks

### Task 1: Save your working directory path
1. Start the lab in your terminal:
   ```bash
   tld start lnx-pwd-navigation
   ```
2. Navigate to your user's home directory and save the output of the `pwd` command to a file named `current_path.txt` in your home directory:
   ```bash
   cd ~
   pwd > ~/current_path.txt
   ```
3. Verify the task to earn your XP:
   ```bash
   tld check
   ```

### Task 2: Navigate to a nested target folder
1. Start the lab in your terminal:
   ```bash
   tld start lnx-cd-home
   ```
2. The setup script created a directory `~/navigation-test/target`. Use `cd` to navigate inside it.
3. Save the output of `pwd` while inside that folder to a file named `path.txt` inside the `~/navigation-test` directory:
   ```bash
   cd ~/navigation-test/target
   pwd > ~/navigation-test/path.txt
   ```
4. Verify the task to earn your XP:
   ```bash
   tld check
   ```

### Task 3: Find a deeply nested directory path
1. Start the lab in your terminal:
   ```bash
   tld start lnx-find-target-directory
   ```
2. Locate the folder named `target` nested inside `~/search-zone`.
3. Save its absolute path (e.g. `/home/fsociety/search-zone/sub1/sub2/sub3/target`) to a file named `found_path.txt` in your home directory:
   ```bash
   echo "/home/fsociety/search-zone/sub1/sub2/sub3/target" > ~/found_path.txt
   ```
4. Verify the task:
   ```bash
   tld check
   ```
