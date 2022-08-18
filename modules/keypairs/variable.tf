variable "path_to_public_key" {
  default     = "~/cloud_devops/Ansible_AutoDiscovery_Project/server_keypair.pub"
  description = "This is the path to our public key"
}

variable "keypair" {
  default = "server_keypair"
}