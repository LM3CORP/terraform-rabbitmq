variable "region" {
  type        = "string"
  description = "The AWS region."
}

variable "key_name" {
  description = "The AWS Key pair to use for resources"
}

variable "region_list" {
  type        = "list"
  description = "AWS availability zones"
}

variable "instance_type" {
  description = "The instance type to launch"
}

variable "instance_server_ips" {
  type        = "list"
  description = "The IPs to use for our server resources"
}

variable "server_ami" {
  type = "map"
}
