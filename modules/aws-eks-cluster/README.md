# aws-eks-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



## Example

```hcl
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

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  value       = module.this.result
}
```
<!-- markdownlint-disable -->

## Modules

No modules.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.cluster_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | ARN of the IAM role that provides permissions for the Kubernetes control<br>plane to make calls to AWS API operations on your behalf. | `string` | n/a | yes |
| <a name="input_cluster_public_access_cidrs"></a> [cluster\_public\_access\_cidrs](#input\_cluster\_public\_access\_cidrs) | List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS<br>public API server endpoint when enabled. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_security_group_ids"></a> [cluster\_security\_group\_ids](#input\_cluster\_security\_group\_ids) | List of security group IDs for the cross-account elastic network interfaces<br>that Amazon EKS creates to use to allow communication between your worker<br>nodes and the Kubernetes control plane. | `list(string)` | `null` | no |
| <a name="input_cluster_subnet_ids"></a> [cluster\_subnet\_ids](#input\_cluster\_subnet\_ids) | List of subnet IDs. Must be in at least two different availability zones.<br>Amazon EKS creates cross-account elastic network interfaces in these<br>subnets to allow communication between your worker nodes and the Kubernetes<br>control plane. If omited the subnets from the Default VPC will be used. | `list(string)` | `null` | no |
| <a name="input_enable_private_access_endpoint"></a> [enable\_private\_access\_endpoint](#input\_enable\_private\_access\_endpoint) | Whether the Amazon EKS private API server endpoint is enabled. | `bool` | `true` | no |
| <a name="input_enable_public_access_endpoint"></a> [enable\_public\_access\_endpoint](#input\_enable\_public\_access\_endpoint) | Whether the Amazon EKS public API server endpoint is enabled. | `bool` | `false` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | Backplane log types to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result"></a> [result](#output\_result) | The result of the module. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
