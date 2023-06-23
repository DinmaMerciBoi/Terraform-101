output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "LB_DNS_Name" {
  value = aws_lb.schoolapp.dns_name
  description = "The LB domain name"
}

output "tags" {
  value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
  description = "ASG tags"
}
