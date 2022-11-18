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
# variable "target-group-arn" {
#     default = ""  
# }
variable "asg-policy" {
    default = ""  
}