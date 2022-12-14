/**
  * <!-- Module outputs go here.
  *      Always include descriptions as they will populate
  *      autogenerated documentation. -->
*/

output "result" {
  description = <<-EOT
      The result of the module.
    EOT
  value = [for org in toset([
    aws_organizations_account.destructible,
    aws_organizations_account.indestructible
  ]) : org if org != []][0][0]
}
