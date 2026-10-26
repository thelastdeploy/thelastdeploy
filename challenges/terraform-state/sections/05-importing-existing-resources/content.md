# Importing Existing Resources

If you have pre-existing infrastructure created manually, you can bring it under Terraform management using `terraform import`.

## Import Syntax:
```bash
terraform import <RESOURCE_TYPE>.<RESOURCE_NAME> <RESOURCE_ID>
```

### Example:
```bash
terraform import terraform_data.existing existing_id
```
After running import, write the matching `resource "terraform_data" "existing"` block in your code to complete adoption.

---

## Lab Tasks

### Task 1: Import an Existing Resource into State
1. Start the lab in your terminal:
   ```bash
   tld start tf-import-resource
   ```
2. Navigate to `~/terraform-state-challenge`:
   ```bash
   cd ~/terraform-state-challenge
   ```
3. Import the existing resource into the declared `terraform_data.existing` resource:
   ```bash
   terraform import terraform_data.existing existing_id
   ```
4. Verify the task:
   ```bash
   tld check
   ```
