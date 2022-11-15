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
