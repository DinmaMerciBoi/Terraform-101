output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "tags" {
  value       = aws_autoscaling_group.webserver.tag
  description = "ASG tags"
}

# output "tags" {
#   value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
#   description = "ASG tags"
# }

# output "tags" {
#   value       = zipmap([for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]], [for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]])
#   description = "ASG tags"
# }
