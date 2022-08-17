output "Bastion_IP" {
  value       = aws_instance.bastion_host.public_ip
  description = "Bastion public IP"
}