module "vpc" {
  source = "./modules/vpc/"
  cidr_block = "10.220.0.0/16"
  cidr_block_public = "10.220.1.0/24"
  zone = "ap-southeast-1a"
}

module "secutity_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2_instance" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  public_key = var.public_key
  subnet_id = module.vpc.subnet_id
  sg_app_id = module.secutity_group.security_group_application_id
  sg_jens_id = module.secutity_group.security_group_jenkins_id
  sg_mor_id = module.secutity_group.security_group_monitor_id
  sg_sec_id = module.secutity_group.security_group_security_id
  eip_app_id = module.vpc.appserver_id
  eip_jens_id = module.vpc.jenkins_id
  eip_mor_id = module.vpc.monitor_id
  eip_sec_id = module.vpc.security_id
}

module "s3" {
  source = "./modules/s3"
}

resource "local_file" "ansible_inventory" {
  content  = <<EOT
[jenkins]
jenkins_server ansible_host=${module.vpc.jenkins_ip}

[app]
app_server ansible_host=${module.vpc.appserver_ip}

[monitor]
monitor_server ansible_host=${module.vpc.monitor_ip}

[security]
security_server ansible_host=${module.vpc.security_ip}

[node_exporter]
jenkins_server
app_server
security_server

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/DevSecOps.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
jenkins_ip=${module.vpc.jenkins_ip}
appserver_ip=${module.vpc.appserver_ip}
monitor_ip=${module.vpc.monitor_ip}
security_ip=${module.vpc.security_ip}
EOT
  filename = "../ansible/inventory.ini"
}