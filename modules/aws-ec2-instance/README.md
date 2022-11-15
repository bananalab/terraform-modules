# aws-ec2-instance

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
<!-- This will become the header in README.md
     Add a description of the module here.
     Do not include Variable or Output descriptions. -->

## Example

```hcl
/**
  * Examples should illustrate typical use cases.
  * For multiple examples each should have its own directory.
  *
  * > Running module examples uses a local state file.
  * > If you delete the .terraform directory the resources
  * > will be orphaned.
*/

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_pet" "name" {}

module "this" {
  source        = "../../"
  ami_id        = data.aws_ami.ubuntu.id
  name          = random_pet.name.id
  instance_type = "t2.micro"
  subnet_id     = "subnet-0cb5507e389ce941e"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>4 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ID of the AMI. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance to create. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the instance. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet to place the NIC in. | `string` | n/a | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone to place the instance. | `string` | `null` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Size of the volume in gibibytes (GiB). | `number` | `null` | no |
| <a name="input_ebs_volume_throughput"></a> [ebs\_volume\_throughput](#input\_ebs\_volume\_throughput) | Throughput to provision for a volume in mebibytes per second (MiB/s). This<br>is only valid for volume\_type of gp3. | `number` | `null` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1,<br>or st1. | `string` | `"gp2"` | no |
| <a name="input_enable_public_ip"></a> [enable\_public\_ip](#input\_enable\_public\_ip) | Whether to associate a public IP address with an instance in a VPC. | `bool` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Key to encrypt EBS Volume with. | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of subnet ids to associate the NIC with. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the instance.  Do not include 'Name' | `map(string)` | `null` | no |
| <a name="input_user_data_b64"></a> [user\_data\_b64](#input\_user\_data\_b64) | Base64 encoded userdata. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result"></a> [result](#output\_result) | The result of the module. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
