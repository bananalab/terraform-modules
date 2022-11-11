output "result" {
  description = <<-EOT
      The result of the module.
    EOT
  value = {
    vpc             = aws_vpc.this
    public_subnets  = aws_subnet.public
    private_subnets = aws_subnet.private
  }
}
