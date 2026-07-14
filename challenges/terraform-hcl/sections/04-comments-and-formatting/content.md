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
