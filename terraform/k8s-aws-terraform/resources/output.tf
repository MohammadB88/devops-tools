output "ec2instance" {
  value = aws_instance.k8s_server[*].public_ip
}