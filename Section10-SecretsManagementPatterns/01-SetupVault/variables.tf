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

variable "vault_port" {
  type        = number
  description = "Vault listening port"
  default     = 8200
}

variable "vault_zip_file" {
  type = string
  description = "Vault download path"
  default = "https://releases.hashicorp.com/vault/1.11.4/vault_1.11.4_linux_amd64.zip"
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "vaultserver"
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
