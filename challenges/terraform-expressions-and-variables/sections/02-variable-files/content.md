# Variable Files

To assign values to variables, you can use `.tfvars` files, environment variables, or CLI arguments.

## Loading Order and Precedence:
Terraform loads variables in the following order (last loaded wins):
1. Environment variables (`TF_VAR_variable_name`)
2. The `terraform.tfvars` file
3. The `terraform.tfvars.json` file
4. Any `*.auto.tfvars` files
5. `-var` and `-var-file` options on the command line

## Syntax of terraform.tfvars:
```hcl
filename = "/tmp/my_file.txt"
content  = "Hello World"
```

---

## Lab Tasks

### Task 1: Define Variable Default Values
1. Start the lab in your terminal:
   ```bash
   tld start tf-default-values
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf` and add a `default` attribute to the `app_name` variable block:
   ```hcl
   variable "app_name" {
     type    = string
     default = "my-awesome-app"
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Use a terraform.tfvars File
1. Start the lab in your terminal:
   ```bash
   tld start tf-use-tfvars
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Create a `terraform.tfvars` file setting the `filename` variable:
   ```hcl
   filename = "/tmp/tfvars_output.txt"
   ```
4. Initialize the workspace and apply the configuration:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
5. Verify the task:
   ```bash
   tld check
   ```
