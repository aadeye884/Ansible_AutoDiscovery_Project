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