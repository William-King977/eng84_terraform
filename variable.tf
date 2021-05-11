# Creating variables to apply DRY
# Variables can be called on main.tf
variable "aws_vpc_name" {
  default = "eng84_william_terraform_vpc"
}

variable "webapp_name" {
  default = "eng84_william_terraform_web"
}

variable "webapp_ami_id" {
  default = "ami-0b1ba632b3ed6e2d7"
}

variable "aws_subnet_name" {
  default = "eng84_william_terraform_subnet"
}

variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}


