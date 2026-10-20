# Expressions

Expressions allow you to dynamically compute values inside HCL configurations.

## String Interpolation
You can embed variables or expressions in double-quoted strings using the `${}` syntax:
```hcl
variable "name" {
  default = "DevOps"
}

resource "local_file" "welcome" {
  content  = "Welcome to ${var.name} track!"
  filename = "/tmp/welcome.txt"
}
```

## Basic Mathematical & Logical Expressions
HCL supports standard mathematical operators (`+`, `-`, `*`, `/`) and logical operators (`&&`, `||`, `!`).

---

## Lab Tasks

### Task 1: Use Basic Expressions
1. Start the lab in your terminal:
   ```bash
   tld start tf-basic-expressions
   ```
2. Navigate to the challenge directory:
   ```bash
   cd ~/terraform-hcl-challenge
   ```
3. Edit `main.tf` to update the `content` argument of the `local_file` resource using string interpolation syntax (`${...}`):
   ```hcl
   resource "local_file" "expr" {
     content  = "Running in directory: ${path.module}"
     filename = "/tmp/expr.txt"
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```
