variable "region_in" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type = string
  description = "The id of the VPC"
}

variable "ssh_port" {
  type        = number
  description = "SSH port number for EC2 ingress in security group."
  default     = 22
  validation {
    condition     = var.ssh_port == 22
    error_message = "SSH Port has to be port 22."
  }
}

variable "http_port" {
  type        = number
  description = "http port number for EC2 ingress in security group"
  default     = 80
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "schoolapp"
}

variable "mytags" {
  description = "Tags"
  type = map
}

variable "subnets" {
  description = "Subnets to work with"
  type = list
}