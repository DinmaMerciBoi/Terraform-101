# Variable Assignment in Files

You can use files to assign values to variables instead of using environment variables or the cli or using the defaults in the variable declarations.

You can use multiple `*.auto.tfvars` and/or `terraform.tfvars`. Many times `terraform.tfvars` is used for any sensitive variables that you don't want to check into git. However, that's not always the case and we will see in later sections better ways to manage sensitive variables.

## Examine the `variables1.auto.tfvars` and `terraform.tfvars` Files

Take a look at `variables1.auto.tfvars` and `terraform.tfvars` files. We assigned most variables in `variables1.auto.tfvars` and only the `my_aws_key` variable in `terraform.tfvars`, pretending that it's a sensitive variable.

Notice how we've assigned `region = "us-east-2"` in the `variables1.auto.tfvars` file. This will override the default value in the `variables.tf` file.

## Terraform Apply

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

> Note that the EC2 instance will appear in Ohio (us-east-2). So if you're looking for it in the console, make sure to change the region at the top right corner of the screen.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.