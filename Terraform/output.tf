output "ec2_public_ip" {
  value = aws_eip.node_app_eip.public_ip
}

output "app_url" {
  value = "http://${aws_eip.node_app_eip.public_ip}:${var.app_port}"
}
