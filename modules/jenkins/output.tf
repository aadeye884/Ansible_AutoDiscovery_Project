output "Jenkins_IP" {
  value       = aws_instance.Jenkins_Server.private_ip
  description = "Jenkins private IP"
}

output "Jenkins-instance" {
  value = aws_instance.Jenkins_Server.id
}