
locals {
  cluster_name_camel = (
    replace(title(join(" ", split("-", var.cluster_name))), " ", "")
  )
}

data "aws_iam_policy_document" "cluster_assume_role" {
  count = var.cluster_role_arn == null ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  count = var.cluster_role_arn == null ? 1 : 0
  name  = "EKSClusterRoleFor${local.cluster_name_camel}"
  assume_role_policy = (
    data.aws_iam_policy_document.cluster_assume_role[0].json
  )
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

locals {
  cluster_role_arn = (
    var.cluster_role_arn == null ?
    aws_iam_role.cluster[0].arn :
    var.cluster_role_arn
  )
}

data "aws_subnets" "default" {
  count = var.cluster_subnet_ids == null ? 1 : 0
  filter {
    name   = "default-for-az"
    values = [true]
  }
}

locals {
  cluster_subnet_ids = (
    var.cluster_subnet_ids == null ?
    data.aws_subnets.default[0].ids :
    var.cluster_subnet_ids
  )
}

resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  role_arn                  = local.cluster_role_arn
  enabled_cluster_log_types = var.enabled_cluster_log_types
  vpc_config {
    endpoint_private_access = var.enable_private_access_endpoint
    endpoint_public_access  = var.enable_public_access_endpoint
    public_access_cidrs     = var.cluster_public_access_cidrs
    security_group_ids      = var.cluster_security_group_ids
    subnet_ids              = local.cluster_subnet_ids
  }
}
