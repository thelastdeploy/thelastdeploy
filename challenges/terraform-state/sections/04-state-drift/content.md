# State Drift

**State Drift** occurs when infrastructure resources are modified out-of-band (e.g. via cloud console or manual CLI commands) independently of Terraform.

## How Terraform Handles Drift:
1. When running `terraform plan` or `terraform apply`, Terraform refreshes its state by querying real resources.
2. If real-world infrastructure differs from state or code, Terraform displays planned updates or replacements to align infrastructure back with code.
