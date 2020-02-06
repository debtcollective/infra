## Postgres Setup

We cannot use SSH tunnels with the Postgres provider, and our [RDS](https://aws.amazon.com/rds/) instances are only accesable from within the [VPC](https://aws.amazon.com/vpc/)

As a work around, we are using a local ssh tunnel and make Terraform use `localhost` as host for the Postgres database.

You can create a tunnel with:

```bash
ssh -N -L 5432:<rds_address>:5432 bastion@host
```
