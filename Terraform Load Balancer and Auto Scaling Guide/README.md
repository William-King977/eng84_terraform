# Terraform Load Balancer and Auto Scaling
## Load Balancing
### Step 1: Create the Load Balancer
```
resource "aws_lb" "load_balancer" {
  name               = "eng84-william-terraform-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  security_groups    = [aws_security_group.terraform_webapp_sg.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id, aws_subnet.public_subnet_1c.id]
}
```

### Step 2: Create the Target Group
```
resource "aws_lb_target_group" "target_group" {
  name     = "eng84-william-terraform-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.terraform_vpc.id
}
```

### Step 3: Create the Listener
```
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  depends_on = [aws_lb_target_group.target_group, aws_lb.load_balancer]
}
```

## Auto Scaling
### Step 1: Create the Launch Template
```
resource "aws_launch_template" "launch_template" {
  name          = "eng84_william_terraform_lt"
  ebs_optimized = false
  image_id      = var.webapp_ami_id
  instance_type = "t2.micro"
  key_name = var.aws_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.terraform_webapp_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eng84_william_terraform_asg_web"
    }
  }
  
  # Run the provision file when a new instance is launched
  user_data = filebase64("scripts/app/init.sh")
}
```

### Step 2: Create Auto Scaling Group
```
resource "aws_autoscaling_group" "auto_scale" {
  name = "eng84_william_terraform_asg"
  desired_capacity = 3
  max_size         = 3
  min_size         = 3
  
  # Heath checks
  health_check_grace_period = 250
  health_check_type         = "ELB"

  # Attach load balancer in the form of a target group
  target_group_arns = [aws_lb_target_group.target_group.arn]

  vpc_zone_identifier = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id, aws_subnet.public_subnet_1c.id]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.launch_template]
}
```