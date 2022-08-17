variable "my_system" {
    default = ["0.0.0.0/0"]
    description = "this cidr block is open to the world"
}

variable "port_ssh" {
  default     = 22
  description = "this port allows ssh access"
}

variable "port_http" {
  default     = 80
  description = "this port allows http access"
}

variable "custom_port" {
  default     = 8080
  description = "this port allows jenkins access"
}

variable "sg_name" {
  default     = ""
}

variable "sg_name1" {
  default     = ""
}

variable "vpc_id" {
  default     = ""
}

variable "sg_name2" {
  default     = ""
}

variable "sg_name3" {
  default     = ""
}

variable "port_mysql" {
  default     = 3306
}

variable "sg_name4" {
  default     = ""
}