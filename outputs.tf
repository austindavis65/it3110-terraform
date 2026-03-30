output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.load_balancer_dns_name
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = module.alb.load_balancer_arn
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ec2_asg.autoscaling_group_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${module.alb.load_balancer_dns_name}"
}
