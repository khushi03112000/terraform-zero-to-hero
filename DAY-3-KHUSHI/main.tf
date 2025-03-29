provider "aws" {
    region = "us-east-1"
}
module "ec2-instance" {
    source = "./modules/ec2-instance"
    ami_value="ami-084568db4383264d4"
    instance_type_value="t2.micro"
}
output "public_ip_address" {
  description = "Output showing for public ip"
value = module.ec2-instance.public_ip
}