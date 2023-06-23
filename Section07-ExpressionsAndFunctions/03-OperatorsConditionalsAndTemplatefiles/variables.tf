variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "my_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "my_aws_key" {
  type        = string
  description = "AWS key to SSH into EC2 instances"
  default     = "mykey.pem"
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

variable "environment" {
  description = "Name of the environment."
  type        = string
  default     = "dev"
}

variable "resource_tags" {
  description = "User defined tags to set for all resources"
  type        = map(string)
  default     = {}
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type        = string
  default     = "10.0.10.0/24"
}

variable "allow_public_ips" {
  description = "Whether to allow the EC2 instances to have public ips or not"
  type        = bool
  default     = false
}

variable "private_ips" {
  description = "A list of private IPs to use with our EC2 instances"
  type        = list(string)
  default     = ["10.0.10.10", "10.0.10.11", "10.0.10.12"]
}

variable "display_version" {
  description = "A boolean to decide whether to display the verion of our app"
  type        = bool
  default     = true
}

variable "app_version" {
  description = "The version of our app"
  type        = string
}
