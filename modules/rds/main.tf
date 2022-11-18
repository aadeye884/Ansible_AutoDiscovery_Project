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