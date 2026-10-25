# State Commands

Advanced state management commands allow refactoring code without destroying resources:

- `terraform state mv <OLD_ADDRESS> <NEW_ADDRESS>`: Renames a resource in state.
- `terraform state rm <ADDRESS>`: Removes a resource from state tracking without deleting real infrastructure.
- `terraform state pull`: Outputs raw state contents to stdout.

---

## Lab Tasks

### Task 1: Rename Resource using State Move
1. Start the lab in your terminal:
   ```bash
   tld start tf-state-move-resource
   ```
2. Navigate to `~/terraform-state-challenge`:
   ```bash
   cd ~/terraform-state-challenge
   ```
3. Move the resource address in state from `local_file.old_name` to `local_file.new_name`:
   ```bash
   terraform state mv local_file.old_name local_file.new_name
   ```
4. Verify the task:
   ```bash
   tld check
   ```
