output "docker_host_private_ip" {
  value = aws_instance.docker_host.private_ip
}
output "docker-instance" {
  value = aws_instance.docker_host.id
}