# Data Sources

Data sources allow Terraform to fetch data defined outside of Terraform, or read by another separate Terraform configuration.

## Syntax
Unlike resources, data sources are declared using a `data` block:
```hcl
data "local_file" "external" {
  filename = "/tmp/external.txt"
}

resource "local_file" "copy" {
  content  = data.local_file.external.content
  filename = "/tmp/copy.txt"
}
```

---

## Lab Tasks

### Task 1: Read from a Data Source
1. Start the lab in your terminal:
   ```bash
   tld start tf-read-data-source
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-resources-challenge
   ```
3. Create `main.tf` declaring a `local_file` data source that reads `/tmp/external.txt` and copies its content to `/tmp/copy.txt`:
   ```hcl
   data "local_file" "external" {
     filename = "/tmp/external.txt"
   }

   resource "local_file" "copy" {
     content  = data.local_file.external.content
     filename = "/tmp/copy.txt"
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
