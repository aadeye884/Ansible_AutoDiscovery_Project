module "stage_vpc" {
  source = "../../modules/vpc"
}

module "stage_keypair" {
  source   = "../../modules/keypair"
  key_name = "UST1keypair"
}
module "stage_security_group" {
  source   = "../../modules/security_group"
  sg_name  = "jenkins_sg"
  sg_name1 = "bastion_sg"
  sg_name2 = "docker_sg"
  sg_name3 = "rds_sg"
  sg_name4 = "ansible_sg"
  sg_name5 = "docker_lbsg"
  sg_name6 = "jenkins_elbSG"
  vpc_id   = module.stage_vpc.vpc-id
}
module "stage_iam" {
  source = "../../modules/iam"
}
module "stage_ansible" {
  source                 = "../../modules/ansible"
  ami                    = "ami-06640050dc3f556bb"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [module.stage_security_group.AnsibleSG]
  subnet_id              = module.stage_vpc.subnet-id3
  key_name               = module.stage_keypair.key_name
  iam_instance_profile   = module.stage_iam.ansible-node-instance-profile
}
module "stage_bastion" {
  source                 = "../../modules/bastion_host"
  ami                    = "ami-06640050dc3f556bb"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [module.stage_security_group.BastionSG]
  subnet_id              = module.stage_vpc.subnet-id1
  key_name               = module.stage_keypair.key_name
}
module "stage_rds" {
  source    = "../../modules/rds"
  rds_name  = "rds_subnet_group"
  vpc_sg_id = [module.stage_security_group.rdsSG]
  subnet_id = [module.stage_vpc.subnet-id3, module.stage_vpc.subnet-id4]
}
module "stage_jenkins" {
  source                 = "../../modules/jenkins"
  ami                    = "ami-06640050dc3f556bb"
  instance_type          = "t2.medium"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [module.stage_security_group.JenkinsSG]
  subnet_id              = module.stage_vpc.subnet-id3
  key_name               = module.stage_keypair.key_name

}
module "stage_docker" {
  source                 = "../../modules/docker"
  ami                    = "ami-06640050dc3f556bb"
  instance_type          = "t2.medium"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [module.stage_security_group.DockerSG]
  subnet_id              = module.stage_vpc.subnet-id4
  key_name               = module.stage_keypair.key_name
}
module "stage_asg" {
  source              = "../../modules/asg"
  ami-name            = "stage-docker-asg"
  target-instance     = module.stage_docker.docker_id
  depends_on          = [module.stage_docker.docker_id]
  launch-configname   = "stage-docker-lc"
  instance-type       = "t2.medium"
  sg_name2            = [module.stage_security_group.DockerSG]
  key_name            = module.stage_keypair.key_name
  asg-group-name      = "stage-dockerhost-ASG"
  vpc-zone-identifier = [module.stage_vpc.subnet-id3, module.stage_vpc.subnet-id4]
  #target-group-arn    = [module.stage_loadbalancer.target-group-arn]
  asg-policy = "docker-policy-asg"
}
module "stage_lb_jenkins" {
  source       = "../../modules/lb_jenkins"
  subnet_id    = [module.stage_vpc.subnet-id1]
  elb_sg1      = [module.stage_security_group.jenkins_elbSG]
  elb-instance = [module.stage_jenkins.Jenkins_ID]
  elb_tag      = "lb-jenkins"
  elb_name     = "lb-jenkins"
}
module "stage_loadbalancer" {
  source                 = "../../modules/loadbalancer"
  vpc_name               = module.stage_vpc.vpc-id
  vpc_security_group_ids = [module.stage_security_group.docker_lbSG]
  subnet_id1             = [module.stage_vpc.subnet-id1, module.stage_vpc.subnet-id2]


}
module "stage_route53" {
  source      = "../../modules/route53"
  domain_name = "teemone.xyz"
  dns_name    = module.stage_loadbalancer.Load_Balancer_dns
  zone_id     = module.stage_loadbalancer.Load_Balancer_zone_id
}