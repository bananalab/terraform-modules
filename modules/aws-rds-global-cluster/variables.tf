variable "cluster_identifier" {
  type        = string
  description = <<-EOT
    Unique ID of the Aurora global cluster.
  EOT
}

variable "master_username" {
  type        = string
  description = <<-EOT
    Username of the master account.
  EOT
}

variable "master_password" {
  type        = string
  description = <<-EOT
    Password of the master account.
  EOT
}

variable "engine" {
  type        = string
  description = <<-EOT
    Supported Aurora DB engine.
  EOT
  default     = "aurora-postgresql"
}

variable "engine_version" {
  type        = string
  description = <<-EOT
    Supported Aurora DB engine version.
  EOT
  default     = "11.9"
}

variable "database_name" {
  type        = string
  description = <<-EOT
    Name of the default database on cluster creation.
  EOT
  default     = "postgres"
}

variable "instance_class" {
  type        = string
  description = <<-EOT
    Class of cluster instances.
  EOT
  default     = "db.r5.large"
}

variable "primary_region_subnet_ids" {
  type        = list(string)
  description = <<-EOT
    List of subnet IDs that can host DB instances.
    If omited default subnets will be used.
  EOT
  default     = null
}

variable "secondary_region_subnet_ids" {
  type        = list(string)
  description = <<-EOT
    List of subnet IDs that can host DB instances.
    If omited default subnets will be used.
  EOT
  default     = null
}
