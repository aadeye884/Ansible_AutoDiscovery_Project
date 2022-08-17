variable "instance_type" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-0b0af3577fe5e3532"
}

variable "subnet_id" {
    default = "aws_subnet.PRV_SN1.id"
}

variable "availability_zone" {
    default = "us-east-1b"
}

variable "key_name" {
    default = ""
}

variable "vpc_security_group_ids" {
    default = ""
}