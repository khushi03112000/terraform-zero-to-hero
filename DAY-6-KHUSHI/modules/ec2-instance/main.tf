provider "aws" {
  region = "us-east-1"
}
variable "ami_value" {
  description = "ami value"
}
variable "instance_type" {
  description = "instance type value"
}

resource "aws_instance" "server" {
  ami = var.ami_value
  instance_type = var.instance_type
}