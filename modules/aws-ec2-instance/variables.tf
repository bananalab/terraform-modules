/**
  * <!-- Module variables go here.
  *      Always include descriptions as they will populate
  *      autogenerated documentation. -->
*/

variable "ami_id" {
  type        = string
  description = <<-EOT
      ID of the AMI.
    EOT
}

variable "instance_type" {
  type        = string
  description = <<-EOT
    Type of instance to create.
  EOT
}

variable "name" {
  type        = string
  description = <<-EOT
    Name of the instance.
  EOT
}

variable "subnet_id" {
  type        = string
  description = <<-EOT
    Subnet to place the NIC in.
  EOT
}

variable "tags" {
  type        = map(string)
  description = <<-EOT
    Tags to apply to the instance.  Do not include 'Name'
  EOT
  default     = null
}

variable "availability_zone" {
  type        = string
  description = <<-EOT
    Availability zone to place the instance.
  EOT
  default     = null
}

variable "enable_public_ip" {
  type        = bool
  description = <<-EOT
    Whether to associate a public IP address with an instance in a VPC.
  EOT
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = <<-EOT
    Key to encrypt EBS Volume with.
  EOT
  default     = null
}

variable "ebs_volume_throughput" {
  type        = number
  description = <<-EOT
    Throughput to provision for a volume in mebibytes per second (MiB/s). This
    is only valid for volume_type of gp3.
  EOT
  default     = null
}

variable "ebs_volume_size" {
  type        = number
  description = <<-EOT
    Size of the volume in gibibytes (GiB).
  EOT
  default     = null
}

variable "ebs_volume_type" {
  type        = string
  description = <<-EOT
    Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1,
    or st1.
  EOT
  default     = "gp2"
}

variable "security_group_ids" {
  type        = list(string)
  description = <<-EOT
    List of subnet ids to associate the NIC with.
  EOT
  default     = null
}

variable "user_data_b64" {
  type        = string
  description = <<-EOT
    Base64 encoded userdata.
  EOT
  default     = null
}
