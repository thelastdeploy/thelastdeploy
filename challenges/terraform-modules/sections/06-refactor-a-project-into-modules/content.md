# Refactor a Project into Modules

In this capstone exercise, you will convert a monolithic root configuration containing multiple unorganized resources into a modular architecture using local child modules.

---

## Lab Tasks

### Task 1: Refactor Monolithic Project into Modules
1. Start the lab in your terminal:
   ```bash
   tld start tf-refactor-project
   ```
2. Navigate to `~/terraform-modules-challenge`:
   ```bash
   cd ~/terraform-modules-challenge
   ```
3. Create a child module directory `modules/files`:
   ```bash
   mkdir -p modules/files
   ```
4. Move the local file resources into `modules/files/main.tf`:
   ```hcl
   resource "local_file" "f1" {
     content  = "1"
     filename = "/tmp/f1.txt"
   }

   resource "local_file" "f2" {
     content  = "2"
     filename = "/tmp/f2.txt"
   }
   ```
5. Update the root `main.tf` to call the new child module:
   ```hcl
   module "files" {
     source = "./modules/files"
   }
   ```
6. Initialize and validate the configuration:
   ```bash
   terraform init
   terraform validate
   ```
7. Verify the task:
   ```bash
   tld check
   ```
