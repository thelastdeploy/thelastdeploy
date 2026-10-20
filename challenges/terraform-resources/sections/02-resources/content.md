# Resources

Resources are the most important block type in Terraform. They describe one or more infrastructure objects, such as virtual networks, compute instances, or local files.

## Resource Block Syntax
```hcl
resource "provider_resource-type" "local-name" {
  argument1 = value1
  argument2 = value2
}
```
- **Resource Type (`local_file`)**: Denotes the type of infrastructure to manage. It always starts with the provider prefix.
- **Resource Name (`welcome`)**: An internal label to represent this resource within the current Terraform module.

---

## Lab Tasks

### Task 1: Create a Local File Resource
1. Start the lab in your terminal:
   ```bash
   tld start tf-create-local-file
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-resources-challenge
   ```
3. Create `main.tf` with a `local_file` resource block:
   ```hcl
   resource "local_file" "welcome" {
     content  = "Terraform resource demonstration"
     filename = "/tmp/welcome.txt"
   }
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

### Task 2: Create a Random Resource
1. Start the lab in your terminal:
   ```bash
   tld start tf-create-random-resource
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-resources-challenge
   ```
3. Edit `main.tf` to define a random resource (such as `random_id`):
   ```hcl
   provider "random" {}

   resource "random_id" "server" {
     byte_length = 8
   }
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
