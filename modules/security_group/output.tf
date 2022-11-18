output "JenkinsSG" {
  value       = aws_security_group.JenkinsSG.id
}

output "BastionSG" {
  value       = aws_security_group.BastionSG.id
}

output "DockerSG" {
  value       = aws_security_group.DockerSG.id
}

output "rdsSG" {
  value       = aws_security_group.rdsSG.id
}

output "AnsibleSG" {
  value       = aws_security_group.AnsibleSG.id
}

output "docker_lbSG" {
  value       = aws_security_group.docker_lbSG.id
}

output "jenkins_elbSG" {
  value       = aws_security_group.jenkins_elbSG.id
}