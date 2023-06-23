terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-08d4ac5b634553e16"
  # instance_type = "t2.micro"

  tags = {
    "Name" = "webserver-${terraform.workspace}"
  }
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
  description = "EC2 Public IP"
}

output "private_ip" {
  value = aws_instance.webserver.private_ip
  description = "EC2 Private IP"
}
