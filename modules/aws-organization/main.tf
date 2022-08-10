/**
  * <!-- This will become the header in README.md
  *      Add a description of the module here.
  *      Do not include Variable or Output descriptions. -->
  * L1 Module to manage an AWS Organization.
*/

resource "aws_organizations_organization" "indestructible" {
  count                         = var.prevent_destroy ? 1 : 0
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      aws_service_access_principals
    ]
  }
}

resource "aws_organizations_organization" "destructible" {
  count                         = var.prevent_destroy ? 0 : 1
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set

  lifecycle {
    ignore_changes = [
      aws_service_access_principals
    ]
  }
}
