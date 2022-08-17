output "Ansible_IP" {
  value       = aws_instance.Ansible_host.private_ip
  description = "Ansible public IP"
}