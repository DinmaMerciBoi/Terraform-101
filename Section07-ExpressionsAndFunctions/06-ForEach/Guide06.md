# For Each

Count is not always the best way to create multiple resources. In fact it falls short in many cases. Suppose you want to scale back the 3 EC2 instances to 2.

If you use `count = 2`, terraform will destroy one of our EC2 instances but we have no control over which one it will destroy.

A better way is to use `for_each`

## Drawback of Count

### Deploy 3 EC2 Instances with Count

Let's run apply the current configuration with `webserver_count  = 3` in the `variables1.auto.tfvars` file.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands:
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instances and verify that all 3 instances are showing their respective instance id and private ip.

Notice the output:

```bash
private_ip = [
  "10.0.10.10",
  "10.0.10.11",
  "10.0.10.12",
]
private_key = <sensitive>
public_ip = [
  "3.238.126.186",
  "44.201.71.158",
  "35.171.164.62",
]
```

### Scale down to 2 EC2 Instances

Now change `webserver_count  = 2` in the `variables1.auto.tfvars` file and run:

```bash
terraform plan
```

Notice below how terraform decided to destroy the `10.0.10.12` EC2 instance. We really didn't have control over this.

```
Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ private_ip = [
        # (1 unchanged element hidden)
        "10.0.10.11",
      - "10.0.10.12",
    ]
  ~ public_ip  = [
        # (1 unchanged element hidden)
        "44.201.71.158",
      - "35.171.164.62",
    ]
```

Let's destroy this infrastructure now:

```bash
terraform destroy --auto-approve
```

## A better way with For_Each

Notice in `locals.tf`, we added the following:

```bash
  instances = {
    "${local.name_suffix}-1" : var.private_ips[0]
    "${local.name_suffix}-2" : var.private_ips[1]
    "${local.name_suffix}-3" : var.private_ips[2]
  }
```

This `instance` map contains the names of our instances as keys and the private_ips as values. The private_ips are taken from the private_ips list variable.

In the `outputs.tf` file comment and uncomment the below:

```bash
output "tags" {
  # value = local.mytags
  value = [for instance in aws_instance.webserver : instance.tags]
  description = "Instance tags"
}
```

In the `aws_instance` in `main.tf`, comment and uncomment to have the following:

```bash
resource "aws_instance" "webserver" {
  # count                  = var.webserver_count
  for_each               = local.instances
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.my_instance_type
  vpc_security_group_ids = [aws_security_group.security_group1.id]
  subnet_id              = aws_subnet.schoolapp.id
  key_name               = aws_key_pair.mykey.key_name
  # private_ip             = var.private_ips[count.index]
  private_ip             = each.value
  user_data              = local.my_user_data

  user_data_replace_on_change = true

  # tags = local.mytags
  tags = merge(local.mytags, {"Name": each.key})
}
```

`for_each` references our `local.instances`. We use the `each.value` to provide the `private_ips`. We use the `each.key` to provide the names to be merged with our `local.mytags` to form our tags.

Notice that the `outputs.tf` file uses for expressions. Since for_each uses a map, you can't use the splat expression.

## Run Terraform Again with For_Each

Run Terraform plan to make sure everything looks good. If so, run terraform apply.

```bash
terraform plan
terraform apply --auto-approve
```

Notice the output with the tag names

```bash
private_ip = [
  "10.0.10.10",
  "10.0.10.11",
  "10.0.10.12",
]
private_key = <sensitive>
public_ip = [
  "18.232.185.6",
  "44.200.28.40",
  "3.235.177.21",
]
tags = [
  tomap({
    "Name" = "schoolapp-dev-1"
    "department" = "engineering"
    "developer_name" = "sam"
    "environment" = "dev"
    "project" = "schoolapp"
  }),
  tomap({
    "Name" = "schoolapp-dev-2"
    "department" = "engineering"
    "developer_name" = "sam"
    "environment" = "dev"
    "project" = "schoolapp"
  }),
  tomap({
    "Name" = "schoolapp-dev-3"
    "department" = "engineering"
    "developer_name" = "sam"
    "environment" = "dev"
    "project" = "schoolapp"
  }),
]
```

## Delete a Specific EC2 Instance

Now let's delete the `schoolapp-dev-2` EC2 instance with `IP = 10.0.10.11`. Remember we couldn't do that with `count`.

All you need to do is comment out the second item in the instances local in `locals.tf`:

```bash
  instances = {
    "${local.name_suffix}-1" : var.private_ips[0]
    # "${local.name_suffix}-2" : var.private_ips[1]
    "${local.name_suffix}-3" : var.private_ips[2]
  }
```

Run `terraform plan`

Notice the output below and how we are able to pin point which EC2 instance to remove:

```bash
Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ private_ip = [
        "10.0.10.10",
      - "10.0.10.11",
        "10.0.10.12",
    ]
  ~ public_ip  = [
        "18.232.185.6",
      - "44.200.28.40",
        "3.235.177.21",
    ]
  ~ tags       = [
        {
            "Name"           = "schoolapp-dev-1"
            "department"     = "engineering"
            "developer_name" = "sam"
            "environment"    = "dev"
            "project"        = "schoolapp"
        },
      - {
          - "Name"           = "schoolapp-dev-2"
          - "department"     = "engineering"
          - "developer_name" = "sam"
          - "environment"    = "dev"
          - "project"        = "schoolapp"
        },
        {
            "Name"           = "schoolapp-dev-3"
            "department"     = "engineering"
            "developer_name" = "sam"
            "environment"    = "dev"
            "project"        = "schoolapp"
        },
    ]
```

Go ahead and run apply:

```bash
terraform apply --auto-approve
```

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.