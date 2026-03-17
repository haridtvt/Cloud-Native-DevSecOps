output "security_group_jenkins_id" {
  value = aws_security_group.SGJENS.id
}

output "security_group_security_id" {
  value = aws_security_group.SGSEC.id
}

output "security_group_application_id" {
  value = aws_security_group.SGAPP.id
}

output "security_group_monitor_id" {
  value = aws_security_group.SGMOR.id
}
