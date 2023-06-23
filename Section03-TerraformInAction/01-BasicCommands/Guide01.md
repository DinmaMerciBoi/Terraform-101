# Basic Commands

In this lab, we'll take a look at some basic CLI commands and get our first deployment running.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform version
terraform -help
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

Check the AWS console to see the VM instance.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.