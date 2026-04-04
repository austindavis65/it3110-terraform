# Terraform Infrastructure Deployment Report

## Plan Output
```
module.compute.data.aws_ssm_parameter.ubuntu_ami: Reading...
module.vpc.aws_eip.nat: Refreshing state... [id=eipalloc-02b04550cbbc0d804]
module.vpc.aws_vpc.this: Refreshing state... [id=vpc-0c80f4e574e7e1292]
module.compute.data.aws_ssm_parameter.ubuntu_ami: Read complete after 0s [id=/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id]
module.vpc.aws_internet_gateway.this: Refreshing state... [id=igw-0218fcdfabacd865e]
module.vpc.aws_subnet.public[1]: Refreshing state... [id=subnet-0953be84950aa4107]
module.vpc.aws_subnet.private[0]: Refreshing state... [id=subnet-06109726c505ff80c]
module.vpc.aws_subnet.public[0]: Refreshing state... [id=subnet-056de31c43c6faaef]
module.vpc.aws_subnet.private[1]: Refreshing state... [id=subnet-0f6404a0660f83940]
module.security.aws_security_group.alb: Refreshing state... [id=sg-0381089156e6d7e60]
module.compute.aws_lb_target_group.this: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:654654579409:targetgroup/technova-tg/df03ba52088e2d0e]
module.vpc.aws_route_table.public: Refreshing state... [id=rtb-06c29409482a2d60e]
module.vpc.aws_nat_gateway.this: Refreshing state... [id=nat-00bbcdce2319150ff]
module.vpc.aws_route_table.private: Refreshing state... [id=rtb-024250c6ffe0aff66]
module.vpc.aws_route_table_association.public_assoc[1]: Refreshing state... [id=rtbassoc-0b89703cac555d948]
module.vpc.aws_route_table_association.public_assoc[0]: Refreshing state... [id=rtbassoc-066b667a575ddc62f]
module.security.aws_security_group.ec2: Refreshing state... [id=sg-01a728967de43d58b]
module.compute.aws_lb.this: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:654654579409:loadbalancer/app/technova-alb/41d8ba99a1ec92f1]
module.vpc.aws_route_table_association.private_assoc[0]: Refreshing state... [id=rtbassoc-04ae71285205d69ef]
module.vpc.aws_route_table_association.private_assoc[1]: Refreshing state... [id=rtbassoc-01a40c1710616fed5]
module.compute.aws_launch_template.this: Refreshing state... [id=lt-08ee18d302f6254c8]
module.compute.aws_autoscaling_group.this: Refreshing state... [id=technova-asg]
module.compute.aws_lb_listener.http: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:654654579409:listener/app/technova-alb/41d8ba99a1ec92f1/8f18132b552b7aba]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

## Explanation of Terraform Changes
**What Terraform will change:** The current plan indicates no changes are needed, as the infrastructure already matches the configuration. This means all required resources have been successfully created and are in sync.

**Why Terraform detected those changes initially:** Originally, Terraform detected changes because the region was switched from us-west-2 to us-east-1, and the existing state file contained resources from the old region that no longer existed. Resources like the VPC, subnets, security groups, and load balancer were marked as deleted outside of Terraform's control. After cleaning the state with `terraform state rm` commands, the plan now shows the infrastructure is correctly deployed in us-east-1.

**Whether any resources will be replaced:** No resources are being replaced. All resources are new creations in the us-east-1 region, and the plan confirms everything is in place without modifications.

## Deliverables and Analysis

### Infrastructure Resources Created
The Terraform configuration successfully creates a complete AWS infrastructure stack in us-east-1, including:
- VPC with public and private subnets across two availability zones
- Internet Gateway and NAT Gateway for network connectivity
- Security groups for load balancer and EC2 instances
- Application Load Balancer with target group and listener
- Launch template and Auto Scaling Group for EC2 instances
- Route tables and associations for proper traffic routing

### Design Choices for Scalability and High Availability
The infrastructure was designed with scalability and high availability in mind. The VPC spans two availability zones (us-east-1a and us-east-1b) to ensure redundancy. Public subnets host the load balancer, while private subnets contain the application servers, providing security through network segmentation. The Auto Scaling Group allows automatic scaling based on demand, with a minimum of 2 and maximum of 4 instances. The Application Load Balancer distributes traffic across healthy instances, enabling horizontal scaling. NAT Gateway in the public subnet allows private instances to access the internet for updates while maintaining security.

### Analysis of Two Resources
1. **AWS Application Load Balancer (ALB):** The ALB acts as a reverse proxy that distributes incoming HTTP traffic across multiple EC2 instances in the Auto Scaling Group. It performs health checks on registered targets and only routes traffic to healthy instances, ensuring high availability. The ALB is placed in public subnets and uses a security group that allows inbound HTTP traffic from anywhere, while the listener forwards requests to the target group on port 80.

2. **AWS Auto Scaling Group (ASG):** The ASG automatically manages the number of EC2 instances based on scaling policies. It maintains a desired capacity of 2 instances initially, scaling between 2 and 4 based on load. The ASG uses a launch template that defines the instance configuration, including AMI, instance type, and user data for application deployment. This resource enables automatic scaling to handle varying traffic loads, improving both scalability and cost efficiency.

### Challenges Faced and Solutions
The main challenge was migrating the infrastructure from us-west-2 to us-east-1. Initially, Terraform detected all resources as deleted because they existed in the old region. This caused plan failures due to invalid ARNs. The solution was to remove all outdated resources from the Terraform state using `terraform state rm` commands, allowing Terraform to treat them as new resources to be created in the correct region. Another challenge was ensuring the user data script in the launch template properly installed and started Apache with the sample HTML page. This was overcome by testing the script locally and verifying the AMI's package manager.

### Lessons Learned
Using Terraform taught me the importance of state management in infrastructure as code. The `terraform state` commands are crucial for handling changes like region migrations. From this assignment, I learned how to structure modular Terraform configurations with separate modules for VPC, security, and compute resources, promoting reusability. I also gained experience with AWS networking concepts like subnets, route tables, and security groups. The assignment reinforced the value of immutable infrastructure, where resources are recreated rather than modified, ensuring consistency. Overall, Terraform's declarative approach simplifies complex infrastructure deployment while providing visibility into changes through plans.

### Application Running
The application is a simple web page served by Apache on EC2 instances, displaying "TechnNova Web App". It can be accessed via the Load Balancer's DNS name, which distributes requests across the Auto Scaling Group instances for high availability.

Or it was supposed to be. No matter what I tried nothing actually showed up when I got onto the link. All it showed was a bad gateway error. I looked into the security group as well as the load balancer and everything set up correct but it just wouldn't show me what I was supposed to see.