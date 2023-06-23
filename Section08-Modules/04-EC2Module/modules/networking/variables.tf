variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "mytags" {
  description = "Tags"
  type        = map(any)
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones_subnets" {
  type        = map(string)
  description = "Availability Zones to use with subnets"
}

variable "allow_public_ips" {
  description = "Whether to allow the EC2 instances to have public ips or not"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "inbound_ports" {
  description = "Security Group Ingress Ports Allowed"
  type        = list(any)
}
