provider "aws" {
  region = "us-east-1"
}
variable "ami_value" {
  description = "value"
}
variable "instance_type" {
  description = "value"
  type = map(string)
default = {
  "dev" = "t2.micro"
  "prod" = "t2.xlarge"
  "stage" = "t2.medium"
}
}
module "ec2-instance" {
  source = "./modules/ec2-instance"
  ami_value = var.ami_value
  instance_type = lookup(var.instance_type,terraform.workspace,"t2.micro")
}