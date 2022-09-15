data "aws_vpc" "primary" {
  provider = aws.primary
  default  = true
}

data "aws_vpc" "secondary" {
  provider = aws.secondary
  default  = true
}

data "aws_subnet_ids" "primary" {
  provider = aws.primary
  vpc_id   = data.aws_vpc.primary.id
}

data "aws_subnet_ids" "secondary" {
  provider = aws.secondary
  vpc_id   = data.aws_vpc.secondary.id
}

locals {
  primary_region_subnet_ids = (
    var.primary_region_subnet_ids != null ?
    var.primary_region_subnet_ids :
    data.aws_subnet_ids.primary.ids
  )
  secondary_region_subnet_ids = (
    var.secondary_region_subnet_ids != null ?
    var.secondary_region_subnet_ids :
    data.aws_subnet_ids.secondary.ids
  )
}

resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = var.cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
}

resource "aws_db_subnet_group" "primary" {
  name       = "${var.cluster_identifier}-primary"
  subnet_ids = local.primary_region_subnet_ids
}

resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  cluster_identifier        = "${var.cluster_identifier}-primary-cluster"
  master_username           = var.master_username
  master_password           = var.master_password
  database_name             = var.database_name
  global_cluster_identifier = aws_rds_global_cluster.this.id
  db_subnet_group_name      = aws_db_subnet_group.primary.id
}

resource "aws_rds_cluster_instance" "primary" {
  provider             = aws.primary
  engine               = aws_rds_global_cluster.this.engine
  engine_version       = aws_rds_global_cluster.this.engine_version
  identifier           = "${var.cluster_identifier}-primary-cluster-instance"
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.primary.id
}

resource "aws_db_subnet_group" "secondary" {
  name       = "${var.cluster_identifier}-secondary"
  subnet_ids = local.secondary_region_subnet_ids
}

resource "aws_rds_cluster" "secondary" {
  provider                  = aws.secondary
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  cluster_identifier        = "${var.cluster_identifier}-secondary-cluster"
  global_cluster_identifier = aws_rds_global_cluster.this.id
  skip_final_snapshot       = true
  db_subnet_group_name      = aws_db_subnet_group.secondary.id

  depends_on = [
    aws_rds_cluster_instance.primary
  ]
}

resource "aws_rds_cluster_instance" "secondary" {
  provider             = aws.secondary
  engine               = aws_rds_global_cluster.this.engine
  engine_version       = aws_rds_global_cluster.this.engine_version
  identifier           = "${var.cluster_identifier}-secondary-cluster-instance"
  cluster_identifier   = aws_rds_cluster.secondary.id
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.secondary.id
}
