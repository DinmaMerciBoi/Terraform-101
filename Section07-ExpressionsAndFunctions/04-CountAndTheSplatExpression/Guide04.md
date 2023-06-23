# Count and the Splat Expression

Suppose our application now needs to grow and instead of one web server, we need to expand to 3.

We could create 3 `aws_instance` resources but that would violate the DRY principle.

So let's see how we can leverage the same `aws_instance` and create 3 of them.

## Add Count to the AWS Instance Resource

`count` is a meta-argument defined by the Terraform language. It can be used with modules and with every resource type.

Notice we added the following in the `aws_instance` resource in the `main.tf` file:

```bash
  count                  = var.webserver_count
  private_ip             = var.private_ips[count.index]
```

Here count = 3 as defined by the `webserver_count` variable.

So Terraform will iterate over our `aws_instance` resource 3 times. It will use the same parameters each time.

However, we can't use the same `private_ip`, and that's why we defined it as a list of 3 items. The `count.index` argument counts from 0, 1, 2. This will reference the 3 IP addresses we have in the `private_ip` variable list. These are: 
- "10.0.10.10",
- "10.0.10.11",
- "10.0.10.12",

No other changes are needed except in the `outputs.tf` file which we will see next.

## Use the Splat Expression for Outputs

We still need to make one last modification and that is to our `output.tf` file.

```bash
output "public_ip" {
  value       = aws_instance.webserver[*].public_ip
  description = "EC2 Public IP"
}

output "private_ip" {
  value       = aws_instance.webserver[*].private_ip
  description = "EC2 Private IP"
}
```

Notice in the above output for `public_ip` and `private_ip`, we added this [*] expression which is called the splat expression.

It iterates over all of the elements of the list given to its left and accesses from each one the attribute name given on its right.

So in our case, the splat expression will iterate over the `aws_instance.webserver` list and accesses the `public_ip` and the `private_ip` from each.

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