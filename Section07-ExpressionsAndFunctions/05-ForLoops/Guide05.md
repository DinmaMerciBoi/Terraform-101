# For Loops

A for expression or loop creates a complex type value by transforming another complex type value.

## Updating our Outputs

Let's see this in our `outputs.tf` file:

```bash
output "public_ip" {
  value       = [for instance in aws_instance.webserver : instance.public_ip]
  description = "EC2 Public IPs"
}

output "private_ip" {
  value       = [for instance in aws_instance.webserver : instance.private_ip]
  description = "EC2 Private IPs"
}
```

In this for expression: 
`[for instance in aws_instance.webserver : instance.public_ip]`

Notice that we use an arbitrary name called `instance` in this case and we use it to iterate over the list of `aws_instance.webserver`. Then we create a new list with the public_ip attribute of this instance. Notice that the whole expression is surrounded with the `[]` brackets because it results in a list.

The splat expression provides a more concise way to express a common operation that could otherwise be performed with a for expression.

You could also use the for expression to result in a map like this:
`{for s in var.list : s => upper(s)}`

which may have this output:
```bash
{
  foo = "FOO"
  bar = "BAR"
  baz = "BAZ"
}
```

## Terraform Apply

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands:
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instances and verify that all 3 instances are showing their respective instance id and private ip

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.