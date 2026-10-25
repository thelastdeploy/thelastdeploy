# Validation Errors

Validation errors happen when HCL syntax is valid, but the arguments provided to resources, modules, or variables violate schema constraints.

## Common Causes:
1. **Invalid Attribute Names:** Specifying an argument that the resource type does not accept.
2. **Type Mismatch:** Passing a string where a number or list is expected.
3. **Missing Required Arguments:** Omitting mandatory parameters (e.g., leaving out `filename` on `local_file`).

Run `terraform validate` after `terraform init` to catch schema errors before planning.

---

## Lab Tasks

### Task 1: Fix Validation Errors
1. Start the lab in your terminal:
   ```bash
   tld start tf-fix-validation-errors
   ```
2. Navigate to `~/terraform-troubleshoot-challenge`:
   ```bash
   cd ~/terraform-troubleshoot-challenge
   ```
3. Open `main.tf` and replace `invalid_param = "test"` with the valid `content = "test"` attribute:
   ```hcl
   provider "local" {}

   resource "local_file" "val_bug" {
     content  = "test"
     filename = "/tmp/val.txt"
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
