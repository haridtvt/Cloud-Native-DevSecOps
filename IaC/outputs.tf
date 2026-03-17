output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_jenkins_server_public_ip" {
  value = module.vpc.jenkins_ip
}

output "ec2_application_server_public_ip" {
  value = module.vpc.appserver_ip
}

output "ec2_monitoring_server_public_ip" {
  value = module.vpc.monitor_ip
}

output "ec2_security_server_public_ip" {
  value = module.vpc.security_ip
}