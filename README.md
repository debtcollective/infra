# Infra

Infra contains our set of Terraform scripts that defines our infrastructure.

## Requirements

- Terraform 0.12+ (brew install terraform)

## Backend

We are using [Terraform Cloud](https://terraform.io) for remote state storage. Every main.tf should declare this at the beginning to enable remote state storage. We are passing a specific Terraform version. If you need to manage multiple Terraform version we recommend you to use [tfenv](https://github.com/tfutils/tfenv).

```hcl
terraform {
  required_version = ">=0.12.13"

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
