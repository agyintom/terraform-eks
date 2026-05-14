variable "kubernetes_version" {
  default     = 1.32
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "eu-central-1"
  description = "aws region"
}

variable "github_actions_iam_user_arn" {
  description = "ARN of the GitHub Actions IAM user"
  type        = string
}

variable "admin_iam_user_arn" {
  description = "ARN of the admin IAM user"
  type        = string
}

variable "node_group_role_arn" {
  description = "ARN of the EKS node group IAM role"
  type        = string
}