# Dynamic Blocks

A dynamic block acts much like a for expression, but produces nested blocks instead of a complex typed value.

Dynamic blocks are used within an infrastructure resource to remove the need for multiple duplicate "blocks" of Terraform code. 

## Using Dynamic Blocks

Uncomment and comment the section below in the `networking.tf` file as shown below:

```bash
resource "aws_security_group" "security_group1" {
  name = "${var.project_name}-security-group"

  vpc_id = aws_vpc.schoolapp.id
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "SSH Ingress"
  #   from_port   = var.ssh_port
  #   to_port     = var.ssh_port
  #   protocol    = "tcp"
  # }
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "HTTP Ingress"
  #   from_port   = var.http_port
  #   to_port     = var.http_port
  #   protocol    = "tcp"
  # }

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP Ingress"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
    }
  }

  ...
}
```

Notice that instead of duplicating the ingress block twice for the `secuirty_group`, we can use a dynamic block to define it once.

Here we use the word `dynamic` followed by the block we want to become dynamic, in this case `ingress`.
We then rely on for_each. 

We defined a new local value called `inbound_ports` which is a list holding the `var.http_port` and `var.ssh_port`.

You can see this in the `locals.tf` file:
`inbound_ports = [var.http_port, var.ssh_port]`

Run:

```bash
terraform init
terraform plan
```

Output:

```bash
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
```

Notice how ingress gets expanded to include both ports 80 and 22 in the terraform plan.

## Terraform Apply

Now terraform apply to verify that all works.

Run the following commands:
```bash
terraform apply --auto-approve
```

Check the AWS console to see the VM instances and verify that all 3 instances are showing their respective instance id and private ip.

Check also the security groups

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.