resource "aws_vpc" "schoolapp" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = local.mytags
}

resource "aws_subnet" "schoolapp" {
  vpc_id                  = aws_vpc.schoolapp.id
  cidr_block              = var.subnet_prefix
  map_public_ip_on_launch = var.allow_public_ips

  tags = local.mytags
}

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


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.mytags
}

resource "aws_internet_gateway" "schoolapp" {
  vpc_id = aws_vpc.schoolapp.id

  tags = local.mytags
}

resource "aws_route_table" "schoolapp" {
  vpc_id = aws_vpc.schoolapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.schoolapp.id
  }

  tags = local.mytags
}

resource "aws_route_table_association" "schoolapp" {
  subnet_id      = aws_subnet.schoolapp.id
  route_table_id = aws_route_table.schoolapp.id
}

# resource "aws_eip" "webserver" {
#   instance = aws_instance.webserver.id
#   vpc      = true

#   tags = local.mytags
# }

# resource "aws_eip_association" "webserver" {
#   instance_id   = aws_instance.webserver.id
#   allocation_id = aws_eip.webserver.id
# }
