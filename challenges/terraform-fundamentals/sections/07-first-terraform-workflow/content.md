# First Complete Terraform Workflow

You will now run through the complete workflow of writing configurations, initializing the directory, planning changes, and applying them to create a local text file.

Once applied, check that:
1. The resource (`local_file`) has created the actual file on your local disk.
2. A `terraform.tfstate` file exists in the directory.

---

## Lab Tasks

### Task 1: Complete the First Terraform Workflow
1. Start the lab in your terminal:
   ```bash
   tld start tf-complete-first-workflow
   ```
2. Navigate to the project directory:
   ```bash
   cd ~/terraform-challenge
   ```
3. Inspect the seeded `main.tf` configuration:
   ```bash
   cat main.tf
   ```
4. Initialize the workspace to install the required `local` provider:
   ```bash
   terraform init
   ```
5. Review the execution plan:
   ```bash
   terraform plan
   ```
6. Apply the configuration to create the `/tmp/pet.txt` resource:
   ```bash
   terraform apply -auto-approve
   ```
7. Verify the generated file:
   ```bash
   cat /tmp/pet.txt
   ```
8. Verify the task:
   ```bash
   tld check
   ```
