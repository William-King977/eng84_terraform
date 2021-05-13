# Creating variables to apply DRY
# Variables can be called on main.tf
variable "aws_vpc_name" {
  default = "eng84_william_terraform_vpc"
}

variable "webapp_name" {
  default = "eng84_william_terraform_web"
}

variable "db_name" {
  default = "eng84_william_terraform_db"
}

variable "webapp_ami_id" {
  default = "ami-0b1ba632b3ed6e2d7"
}

variable "db_ami_id" {
  default = "ami-0636832f11967cc7d"
}

variable "aws_public_subnet_name" {
  default = "eng84_william_terraform_public_sn"
}

variable "aws_private_subnet_name" {
  default = "eng84_william_terraform_private_sn"
}


variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}

variable "my_ip" {
  default = "79.75.20.132/32"
}

variable "db_private_ip" {
  default = "59.59.4.109"
}

