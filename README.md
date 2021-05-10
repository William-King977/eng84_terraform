# Orchestration with Terraform
* Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructures. 
* Terraform codifies cloud APIs into declarative configuration files. 
* We will use Terraform for the orchestration part of IaC.

## Benefits
* Cloud independent - works with different cloud providers, allowing for multi-cloud configuration 
* Can effectively scale up/down to meet the current load
* Reduced time to provision
* Ease of use

## Most used Terraform Commands
* `terraform init` - initialises Terraform with the dependencies of the provider mentioned in main.tf
* `terraform plan` - checks the syntax of the code and lists the jobs to be done (in main.tf)
* `terraform apply` - launches and executes the tasks in main.tf
* `terraform destroy` - destroys/terminates services running in main.tf

## Terraform to launch an EC2 with a VPC, subnets, SG services of AWS
The steps involving environment variables are specific for Windows.

### Step 1: Terraform Installation and Setup
1. Download Terraform for the applicable platform here: https://www.terraform.io/downloads.html
2. Extract and place the **terraform** file in a file location of your choice
3. In Search, type and select `Edit the system environment variables`
4. Click `Environment Variables...`
5. Edit the `Path` variable in `User variables`
6. Click `New`, then add the file path of the **terraform** file inside (e.g. `C:\HashiCorp\Terraform`)
7. Click `Ok` until everything closes

### Step 2: Securing AWS keys with Terraform
1. In Search, type and select `Edit the system environment variables`
2. Click `Environment Variables...`
3. Click `New...` for **User variables**
4. Set the **Variable name** as `AWS_ACCESS_KEY_ID` and add the key as the **Variable value**
5. Repeat steps 3 and 4 for `AWS_SECRET_ACCESS_KEY`
6. Click `Ok` until everything closes
* NOTE: Terraform will look for these keys in the environment variables

### Step 3: Creating an EC2 Instance from an AMI
1. First, we have to specify the cloud provider we are using. In this case, AWS.
   ```
   provider "aws" {
     # Define the region to launch the instance (Ireland)
	 region = "eu-west-1"
   }
   ```
2. Now, we can add the code to configure our EC2 instance with an AMI. This will create the web app by using `aws_instance`.
   ```
   resource "aws_instance" "web_app_instance" {
     # Adding the AMI ID
	 ami = "your_ami_id"

	 # Adding the instance type
	 instance_type = "t2.micro"

	 # Enabling a public IP for the web app
	 associate_public_ip_address = true

	 # Specifying the key (to SSH)
	 key_name = "eng84devops"

	 tags = {
       Name = "eng84_william_terraform_web"
     }
   }
   ```

### Step 4: Create a VPC
* To do this, we will use `aws_vpc`.
```
# Create a default VPC
resource "aws_vpc" "terraform_vpc_test" {
  cidr_block = "59.59.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "eng84_william_terraform_vpc"
  }
}
``` 

### Step 5: Create and Assign a Subnet to the VPC
* To do this, we will use `aws_subnet`.
```
# Create and assign a subnet to the VPC
resource "aws_subnet" "subnet_for_vpc" {
  vpc_id            = aws_vpc.terraform_vpc_test.id
  cidr_block        = "59.59.1.0/24"

  tags = {
      Name = "eng84_william_terraform_subnet"
  }
}
```

AMI IDs:<br />
* Web: ami-091a6947402c48d32
* DB:  ami-0da3421e5dfaa16c9