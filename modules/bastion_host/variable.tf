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