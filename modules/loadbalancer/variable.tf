# ELB related variables 
variable "elb_name" {
  default = ""
}
variable "elb_tag" {
  default = ""
}


variable "subnet_id" {
    default = ""
}

variable "elb-sg1" {      #jenkins-sg1
    default = ""
}

variable "elb-instance" {   #jenkins-instance
    default = ""
}


#variables for application lb
variable "lb" {
  default = ""
}
variable "vpc_id" {
    default = ""
}
variable "lb-sg1" {
    default = ""
}
variable "lb-instance" {
    default = ""
}
variable "subnet_id2" {
   default = ""
}
variable "lb_tag" {
   default = ""
}


variable "custom_http" {
    default = 8080
}

variable "tg-name" {
  default = ""
}

variable "healthy_threshold_tg" {
  default = ""
}

variable "unhealthy_threshold_tg" {
  default = ""
}

variable "timeout_tg" {
  default = ""
}
variable "interval_tg" {
  default = ""
}

