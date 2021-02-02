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

# Modules

## Chatwoot

### Enable continuity in the account.

_https://www.chatwoot.com/docs/conversation-continuity#enable-continuity-in-the-account_

Enable inbound_emails (Login to rails console and execute the following)

```ruby
account = Account.find(1)
account.enabled_features # This would list enabled features.
account.enable_features('inbound_emails')
account.save!
```

Set an inbound domain. This is the domain with which you have set up above.

```ruby
account = Account.find(1)
account.domain='domain.com'
account.save!
```

After executing these steps, the mail sent from Chatwoot will have a replyto: in the following format reply+<random-hex>@<domain.com> and reply to those would get appended to your conversation.
