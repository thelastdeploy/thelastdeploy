# Recover a Broken Infrastructure Project

In this final troubleshooting challenge, you will troubleshoot and recover a broken multi-resource project with invalid attributes, missing provider initialization, and unapplied changes.

---

## Lab Tasks

### Task 1: Recover Broken Infrastructure Project
1. Start the lab in your terminal:
   ```bash
   tld start tf-production-recovery
   ```
2. Navigate to `~/terraform-troubleshoot-challenge`:
   ```bash
   cd ~/terraform-troubleshoot-challenge
   ```
3. Open `main.tf` and remove the invalid attribute `bad_attr = 123` so the configuration is valid:
   ```hcl
   resource "local_file" "prod" {
     content  = "Production system"
     filename = "/tmp/prod_rec.txt"
   }
   ```
4. Initialize the workspace to install providers:
   ```bash
   terraform init
   ```
5. Validate the configuration:
   ```bash
   terraform validate
   ```
6. Apply the configuration to restore infrastructure and create state:
   ```bash
   terraform apply -auto-approve
   ```
7. Verify the task:
   ```bash
   tld check
   ```
