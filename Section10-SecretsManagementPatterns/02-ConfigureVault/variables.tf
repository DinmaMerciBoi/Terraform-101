variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}
variable "name" {
  type        = string
  description = "Prefix name"
  default     = "dynamic-aws-creds-vault-admin"
}
