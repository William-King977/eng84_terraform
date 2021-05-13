# AWS Load Balancing and Auto Scaling
## Load Balancing
Select Application Load Balancing.

### Step 1: Configure Load Balancer:
1. Give it a suitable name
2. Ensure it's internet-facing
3. IP address type: ipv4
4. Have HTTP, port 80 listener (default)
5. Select your VPC, then select your public subnet for each AZ
* NOTE: you must have at least two subnets.

### Step 2: Configure Security Settings
* Skip this step

### Step 3: Configure Security Groups
You can either:
* Select your web app security group
* Create a separate security group. This can be used as added security, so that the web app is only accessible through the DNS.

### Step 4: Configure Routing
1. Create a new target group
2. Give it a suitable name
3. Target type: Instance
4. Protocol HTTP, port 80

### Step 5: Register Targets
* You can register a web instance if you want, otherwise skip this step

## Auto Scaling
### Create a Launch Template:
1. Add appropriate name and description
2. Select your web app AMI
3. Instance type: t2.micro
4. Select key pair 
5. Network platform: VPC
6. Add a network interface:
   * Assign your security group
   * Enable auto-assign public IP
7. Expand Advanced details
   * In user data, copy and paste your contents from `init.sh`

### Create Auto Scaling Group:
1. Enter a suitable name
2. Select your launch template
   * Choose the correct version if you modified it
3. Select your VPC
4. Select your public subnets
5. Attach the load balancer you created (target group)
6. The next steps are optional

### Performing the Auto Scaling
1. Select the Auto Scaling Group you just created
2. Edit Group details
3. Adjust the minimum, desired and maximum capacity, then instances will be launched/terminated based on what you input
4. Each new web instance will have the app running (and posts works!)

