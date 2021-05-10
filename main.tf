# Let's initialise Terraform
# AWS - our provider
# This code will launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of the cloud provider
provider "aws" {
  # Define the region to launch the instance
	region = "eu-west-1"
}

# Launching an EC2 instance from our web app AMI
# resource is the keyword that allows us to add AWS resource as task in Ansible
resource "aws_instance" "web_app_instance" {
	# Adding the AMI ID
	ami = "ami-091a6947402c48d32"

	# Adding the instance type
	instance_type = "t2.micro"

	# Specify the credentials from the env vars (needed for older versions)
	# AWS_ACCESS_KEY = "AWS_ACCESS_KEY_ID"
	# AWS_ACCESS_SECRET = "AWS_ACCESS_SECRET"

	# Enabling a public IP for the web app
	associate_public_ip_address = true

	# Specifying the key (to SSH)
	key_name = "eng84devops"

	tags = {
		Name = "eng84_william_terraform_web"
	}
}

# Create a default VPC
resource "aws_vpc" "terraform_vpc_test" {
	cidr_block = "59.59.0.0/16"
	instance_tenancy = "default"
  
	tags = {
		Name = "eng84_william_terraform_vpc"
	}
}

# Create and assign a subnet to the VPC
resource "aws_subnet" "subnet_for_vpc" {
	vpc_id            = aws_vpc.terraform_vpc_test.id
    # availability_zone = "us-west-2a"
    cidr_block        = "59.59.1.0/24"

    tags = {
		  Name = "eng84_william_terraform_subnet"
	}
}