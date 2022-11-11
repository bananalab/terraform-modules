# aws-github-oidc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
<!-- This will become the header in README.md
     Add a description of the module here.
     Do not include Variable or Output descriptions. -->

## Example

```hcl
terraform {
  required_providers {
    # This has to be declared in both the root config and the
    # module or Terraform becomes confused about which
    # provider to use (hasicorp/github or integrations/github).
    github = {
      source  = "integrations/github"
      version = "~> 0.4"
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
```

## Modules

No modules.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>4.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~>3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~>4.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~>3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~>4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [github_actions_secret.aws_oidc_role](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [aws_iam_policy_document.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [http_http.config](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [tls_certificate.github_actions](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization"></a> [organization](#input\_organization) | The Github organization to authorize for OIDC access. | `string` | n/a | yes |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | List of policy ARNs. Github actions will be granted the permissions in these policies. | `list(string)` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Github repo to enable OIDC federation for. | `string` | n/a | yes |
| <a name="input_create_secret"></a> [create\_secret](#input\_create\_secret) | If true a secret AWS\_ROLE\_ARN will be created in the target repo.<br>This environment variable will configure the `configure-aws-credentials`<br>Github action to use the role create by this module. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result"></a> [result](#output\_result) | The result of the module. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
