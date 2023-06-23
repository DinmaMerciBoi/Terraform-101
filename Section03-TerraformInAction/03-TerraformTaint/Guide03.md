# Terraform Taint

Sometimes you need to force terraform to delete and recreate a resource. You can do that with the `terraform taint` command.

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Try out Terraform Taint

Run the following command:

```bash
terraform taint aws_instance.webserver
terraform plan
```
Notice that we have 1 resource to add and 1 to destroy.

You can also untaint a resource by running:

```bash
terraform untaint aws_instance.webserver
terraform plan
```

Notice that we now have no changes.
Let's go ahead and finally taint this resource:

```bash
terraform taint aws_instance.webserver
terraform apply --auto-approve
```

Notice how we now have a new EC2 instance with new IPs.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.