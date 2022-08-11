/**
  * <!-- This will become the header in README.md
  *      Add a description of the module here.
  *      Do not include Variable or Output descriptions. -->
  * L1 Module to manage an AWS Organization account.
*/

# NOTE: `lifecycle` block can't contain expressions, so we need two resources.

resource "aws_organizations_account" "indestructible" {
  count                      = var.prevent_destroy ? 1 : 0
  name                       = var.name
  email                      = var.email
  close_on_deletion          = var.close_on_deletion
  create_govcloud            = var.create_govcloud
  iam_user_access_to_billing = var.iam_user_access_to_billing ? "ALLOW" : "DENY"
  parent_id                  = var.parent_id
  role_name                  = var.role_name
  tags                       = var.tags
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name]
  }
}

resource "aws_organizations_account" "destructible" {
  count                      = var.prevent_destroy ? 0 : 1
  name                       = var.name
  email                      = var.email
  close_on_deletion          = var.close_on_deletion
  create_govcloud            = var.create_govcloud
  iam_user_access_to_billing = var.iam_user_access_to_billing ? "ALLOW" : "DENY"
  parent_id                  = var.parent_id
  role_name                  = var.role_name
  tags                       = var.tags
  lifecycle {
    ignore_changes = [role_name]
  }
}
