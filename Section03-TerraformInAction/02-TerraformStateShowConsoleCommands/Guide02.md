# Terraform State, Show, and Console Commands

In this lab, we'll take a look at some additional CLI commands that are very helpful as we write HCL code. These are:
- terraform state
- terraform show
- terraform console

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Terraform State

Run `terraform state` to see the available options.

You'll mostly use the following two the most:

```bash
terraform state list
terraform state show aws_instance.webserver
```

## Terraform Show

You can also run `terraform show` to view all resource attributes and the outputs. Try this out:

```bash
terraform show
```

## Terraform Console

Terraform offers a console similar to other languages such as python and Node.

```bash
terraform console
```

Try typing the resource `aws_instance.webserver`

You can see the output and now we can focus on specific attributes.

Try typing: `aws_instance.webserver.private_ip`

This is very useful when used with terraform outputs.

## Terraform Output

Let's update our Terraform output in the `main.tf` file to include the private ip of our EC2 instance:

Add the following:
```bash
output "private_ip" {
  value = aws_instance.webserver.private_ip
}
```

Then type `terraform apply` for the state file to get updated. Notice how we now have another output for the private ip in the state file and also shows up in our terraform output.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.