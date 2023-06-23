output "LB_DNS_Name_Out" {
  value = aws_lb.schoolapp.dns_name
  description = "The LB domain name"
}

output "target_group_arn" {
  value = aws_lb_target_group.schoolapp.arn
}