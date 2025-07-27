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

resource "aws_instance" "node_app_instance" {
  ami                    = "ami-0d1b5a8c13042c939"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.node_app_sg.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    docker_image    = var.docker_image
    docker_username = var.docker_username
    docker_password = var.docker_password
  }))

  tags = {
    Name = "NodeAppEC2"
  }

  depends_on = [aws_security_group.node_app_sg]
}

resource "aws_eip" "node_app_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.node_app_instance.id
  allocation_id = aws_eip.node_app_eip.id
}
