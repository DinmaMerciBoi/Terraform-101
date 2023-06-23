# output "public_ip" {
#   value       = aws_instance.webserver[*].public_ip
#   description = "EC2 Public IPs"
# }

# output "private_ip" {
#   value       = aws_instance.webserver[*].private_ip
#   description = "EC2 Private IPs"
# }

output "public_ip" {
  value       = [for instance in aws_instance.webserver : instance.public_ip]
  description = "EC2 Public IPs"
}

output "private_ip" {
  value       = [for instance in aws_instance.webserver : instance.private_ip]
  description = "EC2 Private IPs"
}

output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "tags" {
  value = local.mytags
}
