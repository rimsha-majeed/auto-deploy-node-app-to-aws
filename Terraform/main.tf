terraform {
  backend "s3" {
    bucket         = "terraform-bucket-rimsha"
    key            = "Terraform/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Create Security Group
resource "aws_security_group" "node_app_sg" {
  name        = "node-app-sg"
  description = "Allow SSH and app port"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-app-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "node_app_instance" {
  ami                    = "ami-0d1b5a8c13042c939"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.node_app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo systemctl start docker
              sudo docker run -d -p 3000:3000 ${var.docker_image}
              EOF

  tags = {
    Name = "NodeAppEC2"
  }
}
# Allocate Elastic IP
resource "aws_eip" "node_app_eip" {
  domain = "vpc"  
}

# Associate Elastic IP with EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.node_app_instance.id
  allocation_id = aws_eip.node_app_eip.id
}