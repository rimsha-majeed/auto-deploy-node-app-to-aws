variable "aws_region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "ec2-key" # Name of your AWS key pair (.pem)
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