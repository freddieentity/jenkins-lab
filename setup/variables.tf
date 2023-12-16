variable "aws_region" {
  default = "us-east-1"
}

variable "app" {
  default = "Docker"
}

variable "key_name" {
  default = "docker"
}

variable "ami" {
  default = "ami-08d4ac5b634553e16"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "script" {
  default = "jenkins_setup"
}