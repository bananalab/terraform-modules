/**
  * <!-- This will become the header in README.md
  *      Add a description of the module here.
  *      Do not include Variable or Output descriptions. -->
  Create a minimally configured EC2 instance.
*/

resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids

  tags = {
    Name = var.name
  }
}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_135:EBS optimized is enabled by default on instances that support it.
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.enable_public_ip
  availability_zone           = var.availability_zone
  user_data_base64            = var.user_data_b64
  monitoring                  = true

  tags = merge(
    { Name = var.name },
    var.tags
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_id
    throughput            = var.ebs_volume_throughput
    volume_size           = var.ebs_volume_size
    volume_type           = var.ebs_volume_type
  }

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }
}
