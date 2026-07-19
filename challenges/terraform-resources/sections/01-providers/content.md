# Providers

Providers in Terraform are plugins that enable Terraform to interact with cloud providers, SaaS providers, and other external APIs.

## How Providers Work
Every resource type in Terraform is managed by a provider. For example, AWS resources like `aws_instance` are managed by the `aws` provider, while files are managed by the `local` provider.

## Configuring Providers
You configure providers in a `provider` block:
```hcl
provider "aws" {
  region = "us-east-1"
}
```
If no configurations are required, you can declare an empty block:
```hcl
provider "random" {}
```
When you run `terraform init`, Terraform automatically downloads the plugins for the providers specified in your configuration.
