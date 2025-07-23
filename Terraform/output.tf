output "ec2_public_ip" {
  value = aws_instance.node_app_instance.public_ip
}

output "app_url" {
  value = "http://${aws_instance.node_app_instance.public_ip}:${var.app_port}"
}
