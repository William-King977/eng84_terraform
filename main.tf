# Let's initialise Terraform
# AWS - our provider
# This code will launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of the cloud provider
provider "aws" {
  # Define the region to launch the instance
	region = "eu-west-1"
}

# Create a VPC.
resource "aws_vpc" "terraform_vpc" {
	cidr_block = "59.59.0.0/16"
	instance_tenancy = "default"
  
	tags = {
		Name = var.aws_vpc_name
	}
}

# Create and assign a subnet to the VPC
resource "aws_subnet" "subnet_for_vpc" {
	vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "59.59.1.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = var.aws_subnet_name
	}
}

# Launching an EC2 instance from our web app AMI
# resource is the keyword that allows us to add AWS resource as task in Ansible
resource "aws_instance" "web_app_instance" {
	# var.name_of_resource loads the value from variable.tf
	ami = var.webapp_ami_id

	# Adding the instance type
	instance_type = "t2.micro"

	# Specify the credentials from the env vars (needed for older versions)
	# AWS_ACCESS_KEY = "AWS_ACCESS_KEY_ID"
	# AWS_ACCESS_SECRET = "AWS_ACCESS_SECRET"

	# Enabling a public IP for the web app
	associate_public_ip_address = true

	# Specifying the key (to SSH)
	key_name = var.aws_key_name
	#public_key = var.aws_key_path

  # Assigning a subnet
	subnet_id = aws_subnet.subnet_for_vpc.id

	tags = {
		Name = var.webapp_name
	}
}