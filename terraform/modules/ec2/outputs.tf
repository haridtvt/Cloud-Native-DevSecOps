output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "app_instance_id" {
  value = aws_instance.app_server.id
}

output "security_instance_id" {
  value = aws_instance.security_server.id
}

output "monitor_instance_id" {
  value = aws_instance.monitor_server.id
}