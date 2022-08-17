output "Jenkins_Private_IP" {
  value = module.dev_jenkins.Jenkins_IP
}

output "Docker_private_IP" {
  value = module.dev_docker.docker_host_private_ip
}

output "Ansible_private_IP" {
  value = module.dev_ansible.Ansible_IP
}

output "bastion-host_public_IP" {
  value = module.dev_bastion.Bastion_IP
}

output "Jenkins_lb_dns" {
  value = module.dev_loadbalancer.Jenkins-lb-dns
}

output "Docker-lb_dns" {
  value = module.dev_loadbalancer.docker-lb-dns
}

output "name_server" {
  value = module.dev_route53.name_server
}