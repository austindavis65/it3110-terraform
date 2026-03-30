# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  project_name       = var.project_name
  availability_zones = var.availability_zones
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
  environment           = var.environment
  project_name          = var.project_name
}

# EC2 ASG Module
module "ec2_asg" {
  source = "./modules/ec2_asg"

  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ec2_security_group_id = module.vpc.ec2_security_group_id
  target_group_arn      = module.alb.target_group_arn
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  environment           = var.environment
  project_name          = var.project_name
}
