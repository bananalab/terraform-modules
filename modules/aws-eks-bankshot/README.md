# aws-eks-bankshot

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
<!-- This will become the header in README.md
     Add a description of the module here.
     Do not include Variable or Output descriptions. -->

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
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ../aws-s3-bucket | n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_s3_object.kubeconfig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster to configure. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
| <a name="output_invocation"></a> [invocation](#output\_invocation) | n/a |
| <a name="output_result"></a> [result](#output\_result) | The result of the module. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
