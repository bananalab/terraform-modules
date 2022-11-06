/**
  * Examples should illustrate typical use cases.
  * For multiple examples each should have its own directory.
  *
  * > Running module examples uses a local state file.
  * > If you delete the .terraform directory the resources
  * > will be orphaned.
*/
variable "cluster_name" { default = null }
variable "cluster_role_arn" { default = null }
variable "enable_private_access_endpoint" { default = true }
variable "enable_public_access_endpoint" { default = false }
variable "cluster_security_group_ids" { default = null }
variable "cluster_subnet_ids" { default = null }

resource "random_pet" "name" {
  count = var.cluster_name == null ? 1 : 0
}

locals {
  cluster_name = (
    var.cluster_name != null ? var.cluster_name : random_pet.name[0].id
  )
}

module "eks_cluster" {
  source                         = "../../../aws-eks-cluster"
  cluster_name                   = local.cluster_name
  cluster_role_arn               = var.cluster_role_arn
  enable_private_access_endpoint = var.enable_private_access_endpoint
  enable_public_access_endpoint  = var.enable_public_access_endpoint
  cluster_security_group_ids     = var.cluster_security_group_ids
  cluster_subnet_ids             = var.cluster_subnet_ids
  enabled_cluster_log_types      = []
}

module "this" {
  source       = "../../"
  cluster_name = module.eks_cluster.result.name
}

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  value       = module.this.result
  sensitive   = true
}

output "cluster" {
  value = module.this.cluster
}

output "invocation" {
  value = module.this.invocation
}
