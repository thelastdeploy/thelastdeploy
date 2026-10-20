# Resource Arguments

Resource arguments configure resource attributes. Each resource type supports different arguments.

For example, the `local_file` resource type requires `filename` and optionally accepts `content` or `directory_permission`.

## Arguments vs Attributes:
- **Arguments:** Settings you configure on a resource (inputs).
- **Attributes:** Values returned by a resource after provisioning (outputs, e.g., `id`, `hex`).

---

## Lab Tasks

### Task 1: Update Resource Arguments
1. Start the lab in your terminal:
   ```bash
   tld start tf-update-resource
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-resources-challenge
   ```
3. Inspect `main.tf` and update the `content` argument of the `local_file.app` resource from `"v1"` to an updated value (such as `"v2"`):
   ```hcl
   resource "local_file" "app" {
     content  = "v2"
     filename = "/tmp/app.txt"
   }
   ```
4. Initialize the workspace and apply the changes:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
5. Verify the task:
   ```bash
   tld check
   ```
