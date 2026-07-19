# Provider Errors

Provider errors occur when provider plugins fail to download, initialize, or authenticate with external systems.

## Key Troubleshooting Steps:
- **`Could not load plugin`:** Means `terraform init` has not been run in the directory.
- **`Provider requirements incompatible`:** Occurs when version constraints conflict across modules. Run `terraform init -upgrade` to update provider selections.
