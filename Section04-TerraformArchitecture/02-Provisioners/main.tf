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
  region = "us-east-1"
}

resource "aws_security_group" "security_group1" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Ingress"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
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
  key_name   = "mykey.pem"
  public_key = tls_private_key.mykey.public_key_openssh
}

resource "aws_instance" "webserver" {
  ami                    = "ami-08d4ac5b634553e16"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group1.id]
  key_name               = aws_key_pair.mykey.key_name
  tags = {
    "Name" = "webserver-${terraform.workspace}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.mykey.private_key_pem
    # Connection and provisioner blocks don't have access to the parent resource so we use the keyword self to refer to them. All the attributes of the resource are available.
    host = self.public_ip
  }
  # Writes the date after completion into finished.log locally
  provisioner "local-exec" {
    command = "date >> finished.log"
  }
  # Create private myKey on my computer
  provisioner "local-exec" {
    command = "echo '${tls_private_key.mykey.private_key_pem}' > /tmp/myKey.pem"
  }
  # Change permissions for the key
  provisioner "local-exec" {
    command = "chmod 400 /tmp/myKey.pem"
  }
  # Install the tree and jq utilities in the remote Ubuntu EC2 instance
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sleep 15",
      "sudo apt -y update",
      "sudo apt install tree jq -y"
    ]
  }
  # Copies the file as the root user using SSH
  provisioner "file" {
    source      = "${path.root}/example.txt"
    destination = "/tmp/example.txt"
  }
}

output "public_ip" {
  value       = aws_instance.webserver.public_ip
  description = "EC2 Public IP"
}

output "private_ip" {
  value       = aws_instance.webserver.private_ip
  description = "EC2 Private IP"
}

output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

# Getting the output from private key is via this command below:

# terraform output -raw private_key
