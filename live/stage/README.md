# Stage env

## Variables

We are passing variables using environment variables. The idea is to keep all variables without collisions in a file called `tfvars.env` at the root of the environment.

1. Copy example environment var file with `cp tfvars.env.sample tfvars.env`
1. Replace variables in `tfvars.env`
1. Run `source tfvars.env`
