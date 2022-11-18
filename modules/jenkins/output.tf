output "Jenkins_IP" {
  value       = aws_instance.Jenkins_host.private_ip
  description = "Jenkins private IP"
}
output "Jenkins_ID" {
  value       = aws_instance.Jenkins_host.id
  description = "Jenkins id "
}
