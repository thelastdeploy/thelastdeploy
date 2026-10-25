# Built-in Functions

The Terraform language includes built-in functions that you can call from within expressions to transform and combine values.

## Common Functions:
- **String:** `lower()`, `upper()`, `trimspace()`, `join()`, `replace()`, `format()`
- **Collection:** `length()`, `concat()`, `flatten()`, `element()`, `slice()`
- **Map:** `keys()`, `values()`, `merge()`
- **Encoding:** `jsonencode()`, `yamlencode()`, `base64encode()`

Test built-in functions interactively by running `terraform console`.

---

## Lab Tasks

### Task 1: Use Built-in Collection Functions
1. Start the lab in your terminal:
   ```bash
   tld start tf-list-functions
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf` and add an output block using a collection function (such as `length`):
   ```hcl
   output "user_count" {
     value = length(var.users)
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Use Built-in String Functions
1. Start the lab in your terminal:
   ```bash
   tld start tf-string-functions
   ```
2. Navigate to `~/terraform-expr-challenge`:
   ```bash
   cd ~/terraform-expr-challenge
   ```
3. Open `main.tf` and add an output block using a string function (such as `trim` or `trimspace`):
   ```hcl
   output "clean_text" {
     value = trimspace(var.raw_text)
   }
   ```
4. Verify the task:
   ```bash
   tld check
   ```
