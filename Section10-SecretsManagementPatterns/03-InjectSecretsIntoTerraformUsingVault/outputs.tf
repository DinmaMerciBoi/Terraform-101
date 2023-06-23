output "LB_DNS_Name" {
  value = module.lb.LB_DNS_Name_Out
  description = "The LB domain name"
}

output "tags" {
  value       = module.ec2.tags
}

output "private_key" {
  value     = module.tls.private_key
  sensitive = true
}