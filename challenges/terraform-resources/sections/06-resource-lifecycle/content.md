# Resource Lifecycle

By default, when a resource modification requires recreating it, Terraform destroys the old resource first, then creates the new one. You can customize this behavior using the `lifecycle` block.

## Lifecycle Rules:
1. **`create_before_destroy = true`:** Creates the new resource first, then destroys the old one. Useful for zero-downtime upgrades.
2. **`prevent_destroy = true`:** Prevents Terraform from destroying a resource (rejects the apply if a destroy is required). Excellent for protecting production databases.
3. **`ignore_changes = [...]`:** Ignores changes to specific resource attributes configured outside of Terraform.

---

## Lab Tasks

### Task 1: Configure Resource replacement lifecycle
1. Start the lab in your terminal:
   ```bash
   tld start tf-replace-resource
   ```
2. Navigate to `~/terraform-resources-challenge`.
3. Open `main.tf` and add a `lifecycle` block inside the `local_file.example` resource block specifying `create_before_destroy = true`:
   ```hcl
   resource "local_file" "example" {
     content  = "Lifecycle test"
     filename = "/tmp/lifecycle.txt"

     lifecycle {
       create_before_destroy = true
     }
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```
