# Stage env

Everything should run using Terraform cloud, except for the postgres/setup module. This needs to be run locally because we need to setup a ssh tunnel to access our RDS database, and this isn't supported by Terraform Cloud.
