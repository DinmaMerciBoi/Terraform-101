resource "aws_vpc" "schoolapp" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = var.mytags
}

resource "aws_subnet" "schoolapp" {
  for_each                = var.availability_zones_subnets
  vpc_id                  = aws_vpc.schoolapp.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = var.allow_public_ips
  tags                    = var.mytags
}

resource "aws_security_group" "security_group1" {
  name = "${var.project_name}-security-group"

  vpc_id = aws_vpc.schoolapp.id

  dynamic "ingress" {
    for_each = var.inbound_ports
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

  tags = var.mytags
}

resource "aws_internet_gateway" "schoolapp" {
  vpc_id = aws_vpc.schoolapp.id

  tags = var.mytags
}

resource "aws_route_table" "schoolapp" {
  vpc_id = aws_vpc.schoolapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.schoolapp.id
  }

  tags = var.mytags
}

resource "aws_route_table_association" "schoolapp" {
  for_each       = var.availability_zones_subnets
  subnet_id      = aws_subnet.schoolapp[each.key].id
  route_table_id = aws_route_table.schoolapp.id
}
