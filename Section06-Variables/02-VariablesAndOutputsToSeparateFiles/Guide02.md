# Move Variables and Outputs to Separate Files

Terraform can read configuration from multiple separate files as if they were one file. This is very helpful when we need to organize our code well as the code grows in size. In this lab, we will simply separate the variables and output files from our `main.tf` file.

## Notice variables.tf and outputs.tf

Take a look at the `variables.tf` and `outputs.tf` files. They are now separated from `main.tf`. `main.tf` now contains mainly `resources`and `data` blocks, whereas variable declarations are stored in `variables.tf` and output blocks are stored in `outputs.tf`.

## Add a few more variables

Take a look at the `variables.tf` file and notice how we've added 4 more variables in addition to the `my_instance_type` variable:

- `region`
- `my_aws_key`
- `ssh_port`
- `http_port`

Check the default values and then go to the `main.tf` file to check how these variables are referenced.

## Terraform Apply

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.