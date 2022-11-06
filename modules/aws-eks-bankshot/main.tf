/**
  * <!-- This will become the header in README.md
  *      Add a description of the module here.
  *      Do not include Variable or Output descriptions. -->
*/

locals {
  function_name = "bankshot-${var.cluster_name}"
}

data "archive_file" "this" {
  type             = "zip"
  source_dir       = "${path.module}/lambda"
  output_file_mode = "0666"
  output_path      = "${local.function_name}-lambda.zip"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "iam_for_lambda" {
  name = local.function_name

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
  inline_policy {
    name   = "permissions"
    policy = <<-EOF
      {
        "Version": "2012-10-17",
        "Statement": [{
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${module.s3_bucket.result.bucket}"]
          },
          {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::${module.s3_bucket.result.bucket}/*"]
          },
          {
            "Effect": "Allow",
            "Action": [
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeNetworkInterfaces"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.function_name}:*"
            ]
          }
        ]
      }
    EOF
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

module "s3_bucket" {
  source             = "../aws-s3-bucket"
  bucket_prefix      = local.function_name
  logging_enabled    = false
  enable_replication = false
}

resource "aws_s3_object" "lambda" {
  bucket = module.s3_bucket.result.bucket
  key    = "${local.function_name}-lambda.zip"
  source = data.archive_file.this.output_path
  etag   = filemd5(data.archive_file.this.output_path)
}

resource "aws_s3_object" "kubeconfig" {
  bucket = module.s3_bucket.result.bucket
  key    = "${local.function_name}-kubeconfig.yaml"
  content = templatefile("${path.module}/files/kubeconfig.yaml",
    {
      cluster_arn            = data.aws_eks_cluster.this.arn
      cluster_ca_certificate = data.aws_eks_cluster.this.certificate_authority[0].data
      cluster_endpoint       = data.aws_eks_cluster.this.endpoint
      cluster_token          = data.aws_eks_cluster_auth.this.token
    }
  )
}

resource "aws_lambda_function" "this" {
  s3_bucket        = aws_s3_object.lambda.bucket
  s3_key           = aws_s3_object.lambda.id
  function_name    = local.function_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "bankshot.handler"
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "provided.al2"
  timeout          = 120
  vpc_config {
    security_group_ids = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
    subnet_ids         = data.aws_eks_cluster.this.vpc_config[0].subnet_ids
  }
  lifecycle {
    replace_triggered_by = [
      aws_s3_object.lambda
    ]
  }
}

resource "aws_lambda_invocation" "this" {
  function_name = aws_lambda_function.this.function_name
  input         = <<-EOT
    {
      "kubeconfig": "s3://${aws_s3_object.kubeconfig.bucket}/${aws_s3_object.kubeconfig.id}"
    }
  EOT
  lifecycle {
    replace_triggered_by = [
      aws_lambda_function.this,
      aws_s3_object.kubeconfig
    ]
  }
}
