# VPC related variables 
variable "vpc_cidr" {
    default     = "10.0.0.0/16"
    description = "VPC"
}
variable "PUB_SN1_cidr" {
    default     = "10.0.0.0/24"
    description = "PUB_SN1"
}
variable "PUB_SN2_cidr" {
    default     = "10.0.1.0/24"
    description = "PUB_SN2"
}
variable "PRV_SN1_cidr" {
    default     = "10.0.2.0/24"
    description = "PRV_SN1"
}
variable "PRV_SN2_cidr"{
    default     = "10.0.3.0/24"
    description = "PRV_SN2"
}
variable "az2a"{
    default = "us-east-1a"
}
variable "az2b"{
    default = "us-east-1b"
}
variable "my_system" {
    default = ["0.0.0.0/0"]
}
variable "my_system2" {
    default = "0.0.0.0/0"
}
variable "vpc_name" {
    default = "VPC"
}
variable "pub_subn1" {
    default = "PUB_SN1"
}
variable "pub_subn2" {
    default = "PUB_SN2"
}
variable "prv_subn1" {
    default = "PRV_SN1"
}
variable "prv_subn2" {
    default = "PRV_SN2"
}
variable "igw_name" {
    default = "IGW"
}
variable "nat_gateway" {
    default = "NAT_GW"
}
variable "route_pub_table" {
    default = "RT_Pub_SN"
}
variable "route_prv_table" {
    default = "RT_Prv_SN"
}