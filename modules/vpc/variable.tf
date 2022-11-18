variable "vpc_cidr" {
    default     = "10.0.0.0/16"
}
variable "vpc_name" {
    default = "UST1_VPC"
}
variable "az1"{
    default = "us-east-1a"
}
variable "PubSn1_cidr" {
    default     = "10.0.1.0/24"
}
variable "PubSn1" {
    default = "PubSn1"
}
variable "PubSn2_cidr" {
    default     = "10.0.2.0/24"
}
variable "az2"{
    default = "us-east-1b"
}
variable "PubSn2" {
    default = "PubSn2"
}
variable "igw_name" {
    default = "UST1_IGW"
}
variable "PubSnRT" {
    default = "UST1_PubSnRT"
}
variable "Ngw_name" {
    default = "UST1_NGW" 
}
variable "PrvSnRT" {
    default = "UST1_PrvSnRT"  
}
variable "PrvSn1_cidr" {
    default     = "10.0.3.0/24"
}
variable "PrvSn1" {
    default = "PrvSn1"
}
variable "PrvSn2_cidr" {
    default     = "10.0.4.0/24"
}
variable "PrvSn2" {
    default = "PrvSn2"
}
variable "all" {
    default = "0.0.0.0/0"
}











