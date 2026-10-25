# Resource Reference Errors

Reference errors occur when code tries to access a resource or attribute that does not exist.

## Typical Scenarios:
- **Typo in Resource Identifier:** Calling `local_file.my_file` when the block is named `resource "local_file" "myfile"`.
- **Referencing Non-Existent Attributes:** Trying to read `resource.id` when the provider names that field `resource.name`.
- **Undefined Variables:** Calling `var.env` without declaring `variable "env"` in `variables.tf`.

---

## Lab Tasks

### Task 1: Fix Resource Reference Typos
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-resource-references
   ```
2. Navigate to `~/terraform-troubleshoot-challenge`:
   ```bash
   cd ~/terraform-troubleshoot-challenge
   ```
3. Open `main.tf` and update `local_file.wrong_name.filename` to `local_file.target_file.filename`:
   ```hcl
   resource "local_file" "target_file" {
     content  = "target"
     filename = "/tmp/target.txt"
   }

   resource "local_file" "reader" {
     content  = local_file.target_file.filename
     filename = "/tmp/reader.txt"
   }
   ```
4. Validate the configuration using `terraform validate`:
   ```bash
   terraform validate
   ```
5. Verify the task:
   ```bash
   tld check
   ```
