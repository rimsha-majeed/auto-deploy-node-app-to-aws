variable "aws_region" {
  default = "us-east-2"
}

variable "key_name" {
  description = "SSH Key Pair name for EC2"
  default     = "ec2-key"  
}


variable "instance_type" {
  default = "t2.micro"
}

variable "app_port" {
  default = 3000
}

variable "docker_image" {
  description = "Docker image to run on EC2"
  type        = string
}


variable "docker_username" {
  type = string
}

variable "docker_password" {
  type = string
}