output "Jenkins_Private_IP" {
  value = module.stage_jenkins.Jenkins_IP
}

output "Docker_private_IP" {
  value = module.stage_docker.Docker_IP
}

output "Ansible_private_IP" {
  value = module.stage_ansible.Ansible_IP
}

output "bastion-host_public_IP" {
  value = module.stage_bastion.Bastion_IP
}

output "lb_jenkins_dns" {
  value = module.stage_lb_jenkins.Jenkins-lb-dns
}

output "Docker-lb_dns" {
  value = module.stage_loadbalancer.Load_Balancer_dns
}

output "route53-name" {
  value = module.stage_route53.Route53_name
}

output "name_servers" {
  value = module.stage_route53.name_servers
}