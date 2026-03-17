output "jenkins_ip" {
  value       = aws_eip.JENS.address
}

output "monitor_ip" {
  value       = aws_eip.MOR.address
}

output "security_ip" {
  value       = aws_eip.SEC.address
}

output "appserver_ip" {
  value       = aws_eip.APP.address
}

output "jenkins_id" {
  value       = aws_eip.JENS.id
}

output "monitor_id" {
  value       = aws_eip.MOR.id
}

output "security_id" {
  value       = aws_eip.SEC.id
}

output "appserver_id" {
  value       = aws_eip.APP.id
}


output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "vpc_cidr_block" {
  value = aws_vpc.VPC.cidr_block
}

output "subnet_id" {
  value = aws_subnet.SUBNET.id
}

output "subnet_cidr" {
  value = aws_subnet.SUBNET.cidr_block
}
