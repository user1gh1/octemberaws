output "aws_instance_public_ip" {
  value = "http://${aws_instance.server.public_ip}"
}