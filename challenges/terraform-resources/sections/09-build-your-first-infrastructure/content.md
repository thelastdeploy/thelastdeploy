# Build Your First Infrastructure

You will now put everything you've learned about resources, providers, dependencies, lifecycles, and state files together to provision a multi-resource local project.

---

## Lab Tasks

### Task 1: Build local infrastructure project
1. Start the lab in your terminal:
   ```bash
   tld start tf-build-local-project
   ```
2. Navigate to `~/terraform-resources-challenge`:
   ```bash
   cd ~/terraform-resources-challenge
   ```
3. Create `main.tf` declaring at least two resources (e.g. two `local_file` resources):
   ```hcl
   resource "local_file" "config" {
     content  = "app_env=production\nlog_level=info"
     filename = "/tmp/config.env"
   }

   resource "local_file" "status" {
     content  = "status=ready"
     filename = "/tmp/status.txt"
   }
   ```
4. Initialize and apply the configuration:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
5. Verify the task:
   ```bash
   tld check
   ```
