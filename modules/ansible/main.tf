# Create Ansible Server  (using Red Hat for ami and t2.micro for instance type)
resource "aws_instance" "Ansible_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  
  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install python3 python3-pip -y
sudo alternatives --set python /usr/bin/python3 
sudo pip3 install docker-py 
sudo yum install ansible -y
sudo yum install -y yum-utils -y 
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
cd /etc/ansible
sudo yum install unzip -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo unzip awscliv2.zip
sudo ./aws/install
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update 
sudo ln -svf /usr/local/bin/aws /usr/bin/aws 
sudo yum install vim -y
sudo chown -R ec2-user:ec2-user /etc/ansible
touch Playbook.yaml
touch discovery.sh 
sudo chmod 755 discovery.sh 
touch key.pem 
sudo chmod 400 key.pem
sudo chown -R ec2-user:ec2-user /etc/ansible && chmod +x /etc/ansible
echo "license_key: 984fd9395376105d6273106ec42913a399a2NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y
sudo hostnamectl set-hostname ansible
EOF

  tags = {
    Name = "Ansible_host"
  }
}