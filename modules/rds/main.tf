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
  db_subnet_group_name   = aws_db_subnet_group.RDS_Subnet_Group.name
  vpc_security_group_ids = var.vpc_sg_id
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t2.micro"
  db_name                = "pacpustm2_db_name"
  username               = "admin"
  password               = "Admin123"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = false
  port                   = 3306
}