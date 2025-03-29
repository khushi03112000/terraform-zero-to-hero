output "public_ip" {
  description = "Output showing for public ip"
value = aws_instance.example.public_ip
}