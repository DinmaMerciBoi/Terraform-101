output "LB_DNS_Name" {
  value = module.lb.LB_DNS_Name_Out
  description = "The LB domain name"
}

output "tags" {
  value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
  description = "ASG tags"
}

output "private_key" {
  value     = module.tls.private_key
  sensitive = true
}