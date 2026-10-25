# Creating Your First Module

A child module is simply a directory containing Terraform `.tf` files.

## Calling a Child Module:
From your root module, invoke a child module using a `module` block and specify the `source` argument:
```hcl
module "file_writer" {
  source = "./modules/file_writer"
}
```

When you add or modify a `module` block, always run `terraform init` to let Terraform register the module source.

---

## Lab Tasks

### Task 1: Call a Child Module from Root
1. Start the lab in your terminal:
   ```bash
   tld start tf-call-module
   ```
2. Navigate to `~/terraform-modules-challenge`:
   ```bash
   cd ~/terraform-modules-challenge
   ```
3. Open `main.tf` and add a `module` block calling `./modules/file_writer`:
   ```hcl
   module "file_writer" {
     source = "./modules/file_writer"
   }
   ```
4. Initialize the workspace to register the child module:
   ```bash
   terraform init
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Create a Child Module
1. Start the lab in your terminal:
   ```bash
   tld start tf-create-module
   ```
2. Navigate to `~/terraform-modules-challenge`:
   ```bash
   cd ~/terraform-modules-challenge
   ```
3. Create the child module directory `modules/file_writer`:
   ```bash
   mkdir -p modules/file_writer
   ```
4. Create `modules/file_writer/main.tf` declaring a resource:
   ```hcl
   resource "local_file" "output" {
     content  = "Created by file_writer child module"
     filename = "/tmp/module_output.txt"
   }
   ```
5. Verify the task:
   ```bash
   tld check
   ```
