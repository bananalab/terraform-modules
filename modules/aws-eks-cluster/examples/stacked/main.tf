/**
 WARNING
  When using interpolation to pass credentials to the Kubernetes provider
  from other resources, these resources SHOULD NOT be created in the same
  Terraform module where Kubernetes provider resources are also used. This
  will lead to intermittent and unpredictable errors which are hard to debug
  and diagnose. The root issue lies with the order in which Terraform itself
  evaluates the provider blocks vs. actual resources.
*/
variable "cluster_name" { default = null }
variable "cluster_role_arn" { default = null }
variable "enable_private_access_endpoint" { default = true }
variable "enable_public_access_endpoint" { default = true }
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

module "this" {
  source                         = "../../"
  cluster_name                   = local.cluster_name
  cluster_role_arn               = var.cluster_role_arn
  enable_private_access_endpoint = var.enable_private_access_endpoint
  enable_public_access_endpoint  = var.enable_public_access_endpoint
  cluster_security_group_ids     = var.cluster_security_group_ids
  cluster_subnet_ids             = var.cluster_subnet_ids
  enabled_cluster_log_types      = []
}

data "aws_eks_cluster_auth" "auth" {
  name = module.this.result.name
}

provider "kubernetes" {
  host                   = module.this.result.endpoint
  cluster_ca_certificate = base64decode(module.this.result.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - groups:
        - system:bootstrappers
        - system:nodes
      rolearn: arn:aws:iam::111122223333:role/my-node-role
      username: system:node:{{EC2PrivateDNSName}}
    EOT
  }
}

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  value       = module.this.result
}
