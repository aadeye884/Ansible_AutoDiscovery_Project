module "dev_vpc" {
  source = "../../modules/vpc"
}

module "dev_keypair" {
  source = "../../modules/keypairs"
}

module "dev_security_group" {
  source   = "../../modules/security_group"
  sg_name  = "jenkins_sg"
  sg_name1 = "bastion_sg"
  sg_name2 = "docker_sg"
  sg_name3 = "rds_sg"
  sg_name4 = "ansible_sg"
  vpc_id   = module.dev_vpc.vpc-id
}

module "dev_jenkins" {
  source                 = "../../modules/jenkins"
  vpc_security_group_ids = [module.dev_security_group.JenkinsSG]
  subnet_id              = module.dev_vpc.subnet-id3
  availability_zone      = "us-east-1a"
  key_name               = module.dev_keypair.key_name
}

module "dev_bastion" {
  source                 = "../../modules/bastion_host"
  vpc_security_group_ids = [module.dev_security_group.BastionSG]
  subnet_id              = module.dev_vpc.subnet-id
  availability_zone      = "us-east-1a"
  key_name               = module.dev_keypair.key_name
}

module "dev_docker" {
  source                 = "../../modules/docker"
  vpc_security_group_ids = [module.dev_security_group.DockerSG]
  subnet_id              = module.dev_vpc.subnet-id4
  availability_zone      = "us-east-1b"
  key_name               = module.dev_keypair.key_name
}

# module "dev_rds" {
#   source    = "../../modules/rds"
#   vpc_sg_id = [module.dev_security_group.rdsSG]
#   subnet_id = [module.dev_vpc.subnet-id3, module.dev_vpc.subnet-id4]
#   rds_name  = "rds_subnet_group"
# }

module "dev_iam" {
  source = "../../modules/iam"
}

module "dev_ansible" {
  source                 = "../../modules/ansible"
  vpc_security_group_ids = [module.dev_security_group.AnsibleSG]
  subnet_id              = module.dev_vpc.subnet-id3
  availability_zone      = "us-east-1a"
  key_name               = module.dev_keypair.key_name
  iam_instance_profile   = module.dev_iam.ansible-node-instance-profile
}

module "dev_loadbalancer" {
  source                 = "../../modules/loadbalancer"
  subnet_id              = [module.dev_vpc.subnet-id]
  subnet_id2             = [module.dev_vpc.subnet-id, module.dev_vpc.subnet-id2]
  elb-sg1                = [module.dev_security_group.JenkinsSG]
  elb-instance           = [module.dev_jenkins.Jenkins-instance]
  lb-sg1                 = [module.dev_security_group.DockerSG]
  vpc_id                 = module.dev_vpc.vpc-id
  lb-instance            = module.dev_docker.docker-instance
  lb                     = "dev-docker-elb"
  lb_tag                 = "dev-docker-elb"
  elb_name               = "dev-jenkins-lb"
  elb_tag                = "dev-jenkins-lb"
  healthy_threshold_tg   = 3
  unhealthy_threshold_tg = 4
  timeout_tg             = 5
  interval_tg            = 30
  tg-name                = "dev-tg"
}

module "dev_asg" {
  source              = "../../modules/asg"
  ami-name            = "dev-docker-asg"
  target-instance     = module.dev_docker.docker-instance
  launch-configname   = "dev-docker-lc"
  instance-type       = "t3.medium"
  ami-from-instance   = module.dev_asg.ami-from-instance
  sg1                 = [module.dev_security_group.DockerSG]
  key_name            = module.dev_keypair.key_name
  asg-group-name      = "dev-dockerhost-ASG"
  vpc-zone-identifier = [module.dev_vpc.subnet-id3, module.dev_vpc.subnet-id4]
  target-group-arn    = [module.dev_loadbalancer.target-group-arn]
  asg-policy          = "docker-policy-asg"
}

module "dev_route53" {
  source      = "../../modules/route53"
  domain_name = "www.elizabethfolzgroup.com"
  lb_dns_name = module.dev_loadbalancer.docker-lb-dns
  lb_zone_id  = module.dev_loadbalancer.docker-lb-zone-id
}