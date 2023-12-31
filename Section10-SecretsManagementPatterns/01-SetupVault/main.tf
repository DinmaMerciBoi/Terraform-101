terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical https://ubuntu.com/server/docs/cloud-images/amazon-ec2
}

resource "aws_security_group" "security_group1" {
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH and Vault Ingress"
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
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = tls_private_key.mykey.public_key_openssh
}

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.my_instance_type
  vpc_security_group_ids = [aws_security_group.security_group1.id]
  key_name               = aws_key_pair.mykey.key_name

  user_data                   = local.my_user_data
  user_data_replace_on_change = true

  tags = local.mytags
}
