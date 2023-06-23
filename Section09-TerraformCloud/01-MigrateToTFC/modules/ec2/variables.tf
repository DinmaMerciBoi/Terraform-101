variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "public_key" {
  description = "Public key from the TLS module"
  type        = string
}

variable "my_aws_key" {
  type        = string
  description = "AWS key to SSH into EC2 instances"
  default     = "mykey.pem"
}

variable "security_group_id" {
  type        = string
  description = "The security group id"
}

variable "my_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "my_user_data" {
  type        = string
  description = "User Data file path"
}

variable "mytags" {
  description = "Tags"
  type        = map(any)
}

variable "subnets" {
  description = "Subnets to work with"
  type        = list(any)
}

variable "target_group_arn" {
  description = "ARN for LB Target Group"
  type        = string
}
