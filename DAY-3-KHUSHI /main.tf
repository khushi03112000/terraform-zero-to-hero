variable "ami_value" {
  description = "enter the ami value"
}
variable "instance_type_value" {
  description = "enter the aws instance type"
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = var.ami_value
  instance_type = var.instance_type_value
}

output "public ip" {
  value = aws_instance.example.public_ip
}