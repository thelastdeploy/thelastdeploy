# Remote State Concepts

For teams, storing state in local `terraform.tfstate` files causes conflicts and risks sensitive data exposure.

## Remote Backends:
A remote backend stores state centrally (e.g. AWS S3, Google Cloud Storage, Terraform Cloud).

### Benefits:
- **Central Storage:** Single source of truth accessible across team members.
- **State Locking:** Uses lock services (e.g. DynamoDB) to block concurrent applies.
- **Encryption:** Secures sensitive values at rest.
