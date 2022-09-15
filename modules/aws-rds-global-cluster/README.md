# aws-rds-global-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->


## Example

```hcl
variable "cluster_identifier" { default = null }
variable "master_username" { default = "postgres" }
variable "master_password" { default = null }
variable "engine" { default = "aurora-postgresql" }
variable "engine_version" { default = "11.9" }
variable "database_name" { default = "postgres" }
variable "db_subnet_group_name" { default = "default" }
variable "instance_class" { default = "db.t2" }


provider "aws" {
  alias  = "primary"
  region = "us-east-2"
}

provider "aws" {
  alias  = "secondary"
  region = "us-east-1"
}

resource "random_pet" "cluster_id" {}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  cluster_identifier = (
    var.cluster_identifier != null ? var.cluster_identifier :
    random_pet.cluster_id.id
  )
  master_password = (
    var.master_password != null ? var.master_password :
    random_password.password.result
  )
}

module "this" {
  source = "../../"
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }
  cluster_identifier = local.cluster_identifier
  master_username    = var.master_username
  master_password    = local.master_password
  engine             = var.engine
  engine_version     = var.engine_version
  database_name      = var.database_name
  //db_subnet_group_name = var.db_subnet_group_name
  instance_class = var.instance_class
}

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  sensitive   = true
  value       = module.this.result
}
```

## Modules

No modules.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | ~> 4.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | ~> 4.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_db_subnet_group.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_global_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_subnet_ids.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | Unique ID of the Aurora global cluster. | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password of the master account. | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username of the master account. | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the default database on cluster creation. | `string` | `"postgres"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Supported Aurora DB engine. | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Supported Aurora DB engine version. | `string` | `"11.9"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Class of cluster instances. | `string` | `"db.t2"` | no |
| <a name="input_primary_region_subnet_ids"></a> [primary\_region\_subnet\_ids](#input\_primary\_region\_subnet\_ids) | List of subnet IDs that can host DB instances.<br>If omited default subnets will be used. | `list(string)` | `null` | no |
| <a name="input_secondary_region_subnet_ids"></a> [secondary\_region\_subnet\_ids](#input\_secondary\_region\_subnet\_ids) | List of subnet IDs that can host DB instances.<br>If omited default subnets will be used. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result"></a> [result](#output\_result) | The result of the module. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
