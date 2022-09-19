terraform {
  required_providers {
    # This has to be declared in both the root config and the
    # module or Terraform becomes confused about which
    # provider to use (hasicorp/github or integrations/github).
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  owner = var.organization
}

variable "repo" {
  default = "terraform-modules"
}

variable "organization" {
  default = "bananalab"
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  ]
}

variable "create_secret" {
  default = true
}

module "this" {
  source        = "../../"
  repo          = var.repo
  policy_arns   = var.policy_arns
  organization  = var.organization
  create_secret = var.create_secret
}

output "result" {
  description = <<-EOT
    The result of the module.
  EOT
  value       = module.this.result
}
