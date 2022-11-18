# AMI From Docker Snapshot
resource "aws_ami_from_instance" "host_ami" {
  name               = var.ami-name
  source_instance_id = var.target-instance
} 
# Creating Autoscaling
resource "aws_launch_configuration" "host_ASG_LC" {
  name = var.launch-configname
  instance_type = var.instance-type
  image_id = aws_ami_from_instance.host_ami.id
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
  name      = var.asg-group-name 
  max_size  = 4
  min_size          = 2
  desired_capacity = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = aws_launch_configuration.host_ASG_LC.name
  vpc_zone_identifier = var.vpc-zone-identifier
  # target_group_arns = var.target-group-arn
}
resource "aws_autoscaling_policy" "host_ASG_POLICY" {
  name = var.asg-policy
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.ASG.name
}