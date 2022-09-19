/**
  * <!-- Module variables go here.
  *      Always include descriptions as they will populate
  *      autogenerated documentation. -->
*/

variable "repo" {
  type        = string
  description = <<-EOT
      Github repo to enable OIDC federation for.
    EOT
}

variable "organization" {
  type        = string
  description = <<-EOT
    The Github organization to authorize for OIDC access.
  EOT
}

variable "policy_arns" {
  type        = list(string)
  description = <<-EOT
    List of policy ARNs. Github actions will be granted the permissions in these policies.
  EOT
}

variable "create_secret" {
  type        = bool
  description = <<-EOT
    If true a secret AWS_ROLE_ARN will be created in the target repo.
    This environment variable will configure the `configure-aws-credentials`
    Github action to use the role create by this module.
  EOT
  default     = true
}