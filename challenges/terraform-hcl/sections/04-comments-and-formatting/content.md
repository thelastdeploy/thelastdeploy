# Comments and Formatting

Comments are vital for explaining why configurations are designed a certain way. HCL supports three commenting styles:

1. `#` - Single-line comment.
2. `//` - Single-line comment (alternative).
3. `/* ... */` - Multi-line comment.

## Example:
```hcl
# This resource writes configuration settings
resource "local_file" "config" {
  /*
     Setting file paths and contents.
     Values are static for testing.
  */
  content  = "AppConfig"
  filename = "/tmp/app.config" // target file path
}
```

Formatting configurations with `terraform fmt` keeps key-value pairs aligned, making code review and collaboration significantly easier.

---

## Lab Tasks

### Task 1: Comment and Format Configuration
1. Start the lab in your terminal:
   ```bash
   tld start tf-format-configuration
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-hcl-challenge
   ```
3. Open `main.tf` and add a comment explaining the resource configuration (using `#`, `//`, or `/* ... */`):
   ```hcl
   # Configuration file for application settings
   resource "local_file" "app" {
     content  = "AppConfig"
     filename = "/tmp/app.config"
   }
   ```
4. Format the file using the Terraform CLI:
   ```bash
   terraform fmt
   ```
5. Verify the task:
   ```bash
   tld check
   ```
