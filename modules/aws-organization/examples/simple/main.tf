/**
  * Examples should illustrate typical use cases.
  * For multiple examples each should have its own directory.
  *
  * > Running module examples uses a local state file.
  * > If you delete the .terraform directory the resources
  * > will be orphaned.
*/

variable "aws_service_access_principals" { default = null }
variable "enabled_policy_types" { default = null }
variable "feature_set" { default = "ALL" }
variable "prevent_destroy" { default = true }

module "this" {
  source                        = "../../"
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
  prevent_destroy               = var.prevent_destroy
}

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  value       = module.this.result
}
