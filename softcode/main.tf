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