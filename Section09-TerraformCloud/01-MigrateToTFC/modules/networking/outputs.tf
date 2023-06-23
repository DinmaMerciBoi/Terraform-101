output "vpc_id" {
  value = aws_vpc.schoolapp.id
}

output "security_group_id" {
  value = aws_security_group.security_group1.id
}

output "subnets" {
  value = [for subnet in aws_subnet.schoolapp : subnet.id]
}