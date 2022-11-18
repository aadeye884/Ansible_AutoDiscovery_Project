# Create a Bastion_Host
resource "aws_instance" "bastion_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  associate_public_ip_address = true
  provisioner "file" {
    source = "~/Keypairs/USTeam1Keypair"
    destination = "/home/ec2-user/USTeam1Keypair"
  }
  connection {
    type = "ssh"
    host = self.public_ip
    private_key = file("~/Keypairs/USTeam1Keypair")
    user = "ec2-user"
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo chmod 400 USTeam1Keypair
  sudo hostnamectl set-hostname bastion
  EOF
  tags = {
    Name = "bastion_host"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "RDS_Subnet_Group" {
  name       = var.rds_name
  subnet_ids = var.subnet_id
  tags = {
    Name = "RDS_subnet_group"
  }
}

# Create RDS Database
resource "aws_db_instance" "RDS_DB" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  parameter_group_name   = "default.mysql8.0"
  identifier             = var.identifier
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  vpc_security_group_ids = var.vpc_sg_id
  db_subnet_group_name   = aws_db_subnet_group.RDS_Subnet_Group.name
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false
}

# RDS Security group = RDS-SG
resource "aws_security_group" "rdsSG" {
  name        = var.sg_name3
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh from VPC"
    from_port   = var.port_mysql
    to_port     = var.port_mysql
    protocol    = "tcp"
    cidr_blocks = var.my_system
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.my_system
  }

  tags = {
    Name = var.sg_name3
  }
} 

# AMI From Docker Snapshot
resource "aws_ami_from_instance" "host_ami" {
  name               = var.ami-name
  source_instance_id = var.target-instance
  depends_on = [aws_instance.docker_host]
} 
# Creating Autoscaling
resource "aws_launch_configuration" "host_ASG_LC" {
  name = var.launch-configname
  instance_type = var.instance-type
  image_id = var.ami-from-instance
  security_groups = var.sg_name2
  key_name        = var.key_name
  user_data = <<-EOF
#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
sudo yum install docker-ce docker-ce-cli -y
sudo yum install python3 python3-pip -y
sudo alternatives --set python /usr/bin/python3
sudo pip3 install docker-py 
sudo systemctl start docker
sudo systemctl enable docker
echo "license_key: 984fd9395376105d6273106ec42913a399a2NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y
sudo usermod -aG docker ec2-user
sudo hostnamectl set-hostname DockerASG
EOF 
}
resource "aws_autoscaling_group"  "ASG" {
  name = var.asg-group-name 
  max_size = 4
  min_size = 2
  desired_capacity = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = aws_launch_configuration.host_ASG_LC.name
  vpc_zone_identifier = var.vpc-zone-identifier
  target_group_arns = var.target-group-arn
}
resource "aws_autoscaling_policy" "host_ASG_POLICY" {
  name = var.asg-policy
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.ASG.name
}

module "stage_asg" {
  source              = "../../modules/asg"
  ami-name            = "stage-docker-asg"
  target-instance     = module.stage_docker.docker-instance
  launch-configname   = "stage-docker-lc"
  instance-type       = "t3.medium"
  ami-from-instance   = module.stage_asg.ami-from-instance
  sg_name2            = [module.stage_security_group.DockerSG]
  key_name            = module.stage_keypair.key_name
  asg-group-name      = "stage-dockerhost-ASG"
  vpc-zone-identifier = [module.stage_vpc.subnet-id3, module.stage_vpc.subnet-id4]
  #target-group-arn    = [module.stage_loadbalancer.target-group-arn]
  asg-policy          = "docker-policy-asg"
}