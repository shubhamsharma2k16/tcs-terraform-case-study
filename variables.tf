
variable "region" {}
variable "profile" {}

variable "ami_name" {}
variable "instance_type" {}
variable "instance_count" {}
variable "mandatory_tags" {}
variable "instance_name" {
  type    = list(any)
  default = ["A", "B"]
}
variable "http_port" {}
variable "public_cidr" {}
variable "https_port" {}
