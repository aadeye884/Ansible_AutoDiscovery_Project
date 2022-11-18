# Create Jenkins Server  (using Red Hat for ami and t2.medium for instance type)
resource "aws_instance" "Jenkins_Server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  user_data = <<-EOF
  #!bin/bash
  sudo yum update -y
  sudo yum install wget -y
  sudo yum install git -y
  sudo yum install maven -y
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo yum update -y
  sudo yum upgrade -y
  sudo yum install jenkins java-11-openjdk-devel -y --nobest
  sudo yum install epel-release java-11-openjdk-
  sudo systemctl daemon-reload
  sudo systemctl start jenkins
  sudo systemctl enable jenkins
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum update -y
  sudo yum install docker-ce docker-ce-cli containerd.io -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo usermod -aG docker jenkins 
  echo "license_key: c32625464fc4f6eae500b09fa88fe0c93434NRAL" | sudo tee -a /etc/newrelic-infra.yml
  sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
  sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
  sudo yum install newrelic-infra -y
  sudo hostnamectl set-hostname Jenkins
  EOF

  tags = {
    Name = "Jenkins_Server"
  }
}