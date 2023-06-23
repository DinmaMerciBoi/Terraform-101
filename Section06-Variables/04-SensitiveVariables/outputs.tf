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

output "security_group_ingress" {
  value = aws_security_group.security_group1.ingress
  sensitive = true
}

# Getting the output from the security group ingress is via this command below:

# terraform output -json security_group_ingress