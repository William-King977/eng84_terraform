# Let's initialise Terraform
# AWS - our provider
# This code will launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of the cloud provider
provider "aws" {
  # Define the region to launch the instance
  region = "eu-west-1"
}

# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "59.59.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = var.aws_vpc_name
  }
}

# Create and assign an Internet Gateway
resource "aws_internet_gateway" "terraform_ig" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "eng84_william_terraform_ig"
  }
}


# Create and assign a public subnet to the VPC
resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "59.59.1.0/24"

  #map_public_ip_on_launch = true # Make it a public subnet
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.aws_public_subnet_name}_1a"
  }
}

# Create and assign a public subnet to the VPC
resource "aws_subnet" "public_subnet_1b" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "59.59.2.0/24"

  #map_public_ip_on_launch = true # Make it a public subnet
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.aws_public_subnet_name}_1b"
  }
}

# Create and assign a public subnet to the VPC
resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "59.59.3.0/24"

  #map_public_ip_on_launch = true # Make it a public subnet
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.aws_public_subnet_name}_1c"
  }
}

# Create and assign a private subnet to the VPC
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "59.59.4.0/24"

  #map_public_ip_on_launch = false
  availability_zone = "eu-west-1c"

  tags = {
    Name = var.aws_private_subnet_name
  }
}





# Create a public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
  }

  tags = {
    Name = "eng84_william_terraform_public_rt"
  }
}

# Add subnet associations for the public subnet
resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_assoc_3" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "eng84_william_terraform_private_rt"
  }
}

# Add subnet associations for the private subnet
resource "aws_route_table_association" "private_subnet_assoc_1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}





# Security Group for the web app
resource "aws_security_group" "terraform_webapp_sg" {
  name = "eng84_william_terraform_web_sg"
  description = "Security group for the webapp spun-up from Terraform"
  vpc_id = aws_vpc.terraform_vpc.id

  # Inbound rules
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access from the browser"
  }

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
    description = "Allow admin to SSH"
  }

  # Outbound rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic out"
  }

  tags = {
    Name = "eng84_william_terraform_web_sg"
  }
}

# Security Group for the database
resource "aws_security_group" "terraform_db_sg" {
  name = "eng84_william_terraform_db_sg"
  description = "Security group for the database spun-up from Terraform"
  vpc_id = aws_vpc.terraform_vpc.id

  # Inbound rules
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.terraform_webapp_sg.id]
    description = "Allow all traffic from the app"
  }

  # Outbound rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # All traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic out"
  }

  tags = {
    Name = "eng84_william_terraform_db_sg"
  }
}





# Launching an EC2 instance from our database AMI
resource "aws_instance" "db_instance" {
  ami = var.db_ami_id

  # Adding the instance type
  instance_type = "t2.micro"

  # Enabling a public IP for the database
  associate_public_ip_address = true

  # Specifying the key (to SSH)
  key_name = var.aws_key_name

  # Assigning a subnet
  subnet_id = aws_subnet.private_subnet.id

  # Security group
  vpc_security_group_ids = [aws_security_group.terraform_db_sg.id]
   
  tags = {
    Name = var.db_name
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

  # Assigning a subnet
  subnet_id = aws_subnet.public_subnet_1c.id

  # Security group
  vpc_security_group_ids = [aws_security_group.terraform_webapp_sg.id]

  # Move the provisions from local machine to the instance
  provisioner "file" {
    source = "scripts/app/init.sh"
    destination = "/home/ubuntu/init.sh"
  }
  
  # Allow it to be executable and run it
  provisioner "remote-exec" {
    inline = [
      # Bashrc doesn't work for some reason
      "echo export DB_HOST='mongodb://${aws_instance.db_instance.private_ip}:27017/posts' | sudo tee -a /etc/profile",
      "chmod +x /home/ubuntu/init.sh",
      "sudo /home/ubuntu/init.sh"
    ]
  }
  
  # Establish the cnnection for provisioning
  connection {
    user        = "ubuntu"
    private_key = file(var.aws_key_path)
    host        = aws_instance.web_app_instance.public_ip
  }
   
  tags = {
    Name = var.webapp_name
  }
  
  # Database must be running first 
  depends_on = [aws_instance.db_instance]
}
