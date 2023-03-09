output "ec2instance" {
  value = [aws_instance.k8s_controlplane.public_ip, aws_instance.k8s_worker.public_ip]
}