/**
  * <!-- Module variables go here.
  *      Always include descriptions as they will populate
  *      autogenerated documentation. -->
*/

variable "cluster_name" {
  type        = string
  description = <<-EOT
      Name of the cluster
    EOT
}

variable "cluster_role_arn" {
  type        = string
  description = <<-EOT
    ARN of the IAM role that provides permissions for the Kubernetes control
    plane to make calls to AWS API operations on your behalf.
  EOT
}

variable "enable_private_access_endpoint" {
  type        = bool
  description = <<-EOT
    Whether the Amazon EKS private API server endpoint is enabled.
  EOT
  default     = true
}

variable "enable_public_access_endpoint" {
  type        = bool
  description = <<-EOT
    Whether the Amazon EKS public API server endpoint is enabled.
  EOT
  default     = false
}

variable "cluster_public_access_cidrs" {
  type        = list(string)
  description = <<-EOT
    List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS
    public API server endpoint when enabled.
  EOT
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_ids" {
  type        = list(string)
  description = <<-EOT
    List of security group IDs for the cross-account elastic network interfaces
    that Amazon EKS creates to use to allow communication between your worker
    nodes and the Kubernetes control plane.
  EOT
  default     = null
}

variable "cluster_subnet_ids" {
  type        = list(string)
  description = <<-EOT
    List of subnet IDs. Must be in at least two different availability zones.
    Amazon EKS creates cross-account elastic network interfaces in these
    subnets to allow communication between your worker nodes and the Kubernetes
    control plane. If omited the subnets from the Default VPC will be used.
  EOT
  default     = null
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = <<-EOT
    Backplane log types to enable
  EOT
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}