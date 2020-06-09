## MySQL Setup

We cannot use SSH tunnels with the MySQL provider, and our [RDS](https://aws.amazon.com/rds/) instances are only accesable from within the [VPC](https://aws.amazon.com/vpc/)

As a work around, we are using a local ssh tunnel and make Terraform use `localhost` as host for the MySQL database.

You can create a tunnel with:

```bash
ssh -N -L 3306:<rds_address>:3306 bastion@host
```

We are binding to the MySQL default port (3306), you must stop MySQL in your local before running the command above.
