# Bastion Variables
variable "instance_type" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-06640050dc3f556bb"
}

variable "subnet_id" {
    default = ""
}

variable "availability_zone" {
    default = "us-east-1a"
}

variable "key_name" {
    default = ""
}

variable "vpc_security_group_ids" {
    default = ""
}

# RDS Variables
variable "subnet_id" {
    default = ""
}

variable "rds_name" {
    default = ""
}

variable "vpc_sg_id" {
    default = ""
}

variable "db_name" {
    default = "pacpdb"
}

variable "username" {
    default = "admin"
}

variable "password" {
    default = "Admin123"
}

variable "identifier" {
  default = "pacpdb"
}

# RDS-SG Variables
variable "my_system" {
    default = ["0.0.0.0/0"]
    description = "this cidr block is open to the world"
}

variable "vpc_id" {
  default     = ""
}

variable "sg_name3" {
  default     = ""
}

variable "port_mysql" {
  default     = 3306
}

#ASG Variables
variable "ami-name" {
  default = ""
}
variable "target-instance" {
  default = ""
}
variable "launch-configname" {
  default = ""
}
variable "instance-type" {
  default = ""
}
variable "ami-from-instance" {
  default = ""
}
variable "sg_name2" {
  default = ""
}
variable "key_name" {
    default = ""  
}
variable "asg-group-name" {
    default = ""  
}
variable "vpc-zone-identifier" {
    default = ""  
}
variable "target-group-arn" {
    default = ""  
}
variable "asg-policy" {
    default = ""  
}