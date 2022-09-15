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
