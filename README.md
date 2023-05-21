# AWS

Personal AWS account configuration and resources.

# Usage

## Requirements

- [tfenv](https://github.com/tfutils/tfenv)
- [direnv](https://github.com/direnv/direnv)
- [aws-vault](https://github.com/99designs/aws-vault/tree/master)

## Note to self

This is the basic account bootstrapping process for my root personal account preserved here should
it ever need to be repeated.

- Create a new AWS account. This will serve as the ["management"
  account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices_mgmt-acct.html).
- Login with the root user
- From the default region, [enable IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/get-started-enable-identity-center.html)
- Create an access key for the root user
- With the root credentials, run `terraform init` and `terraform apply` in `workspaces/management`
  using the __local__ backend (comment out the __s3__ backend configuration)

```
$ cd workspaces/management
$ AWS_ACCESS_KEY_ID=example AWS_SECRET_ACCESS_KEY=secret terraform init
$ AWS_ACCESS_KEY_ID=example AWS_SECRET_ACCESS_KEY=secret terraform apply
```

- Delete the root user access key
- Merge the `aws-config.template` into the standard AWS configuration path - `~/.aws/config`
- Login to the AWS console with the new IAM Identity Center user
- With the new admin role, run `terraform init` and `terraform apply` in `workspaces/global` using
  the __local__ backend (commend out the __s3__ backend configuration)

```
$ aws-vault exec mine.main.admin -- terraform init
$ aws-vault exec mine.main.admin -- terraform apply
```

- Migrate the `workspace/global` state to the __s3__ backend (uncomment the __s3__ backend
  configuration in `workspaces/global/main.tf`)

```
$ aws-vault exec mine.main.admin -- terraform init -migrate-state -backend-config=../backend.hcl
```

- Migrate the `workspace/management` state to the __s3__ backend (uncomment the __s3__ backend
  configuration in `workspaces/management/main.tf`)

```
$ aws-vault exec mine.main.admin -- terraform init -migrate-state -backend-config=../backend.hcl
```
