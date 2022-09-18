/**
  * <!-- This will become the header in README.md
  *      Add a description of the module here.
  *      Do not include Variable or Output descriptions. -->
  ## Terraform module AWS OICD integration GitHub Actions
  This module configures your AWS account and Github actions to interoperate
  without the need for shared credentials.
  See: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
*/

data "http" "config" {
  url = "https://vstoken.actions.githubusercontent.com/.well-known/openid-configuration"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  config = jsondecode(data.http.config.response_body)
}

data "tls_certificate" "github_actions" {
  url = local.config.jwks_uri
}

locals {
  thumprint = data.tls_certificate.github_actions.certificates[0].sha1_fingerprint
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = local.config.issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.thumprint]
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid     = 1
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.organization}/${var.repo}:*"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values   = ["https://token.actions.githubusercontent.com"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  assume_role_policy = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}

resource "github_actions_secret" "aws_oidc_role" {
  count = var.create_secret ? 1 : 0
  #checkov:skip=CKV_SECRET_6:Not really a secret
  repository      = var.repo
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = aws_iam_role.github_actions.arn
}
