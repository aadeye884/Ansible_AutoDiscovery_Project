output "ami-from-instance" {
  value = aws_ami_from_instance.host_ami.id
}