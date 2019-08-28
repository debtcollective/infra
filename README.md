# Infra

Infra contains our set of Terraform scripts that defines our infrastructure.

## Requirements

- Terraform 0.12+ (brew install terraform)

## Backend

We are using [Terraform Cloud](https://terraform.io) for remote state storage. Every main.tf should declare this at the beginning to enable remote state storage.

```hcl
terraform {
  required_version = ">=0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "debtcollective"

    workspaces {
      name = "workspace-name"
    }
  }
}
```

### Workspaces

TBD
