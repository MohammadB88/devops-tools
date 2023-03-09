resource "aws_instance" "k8s_controlplane" {
  ami = lookup(var.ec2_instances, "ami")
  instance_type = lookup(var.ec2_instances, "itype")
  subnet_id = aws_subnet.k8s_subnet.id #FFXsubnet2
  associate_public_ip_address = lookup(var.ec2_instances, "publicip")
  # count = lookup(var.ec2_instances, "instance_count")

  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.name

  key_name = "${aws_key_pair.terraform-demo.key_name}"

  vpc_security_group_ids = [ aws_security_group.k8s-controlplane.id ]

  tags = {
    # Name = "k8s-ec2-${count.index + 1}"
    Name = "k8s-controlplane"
    Managed = "IAC"
  }
  
  depends_on = [ aws_security_group.k8s-controlplane, aws_key_pair.terraform-demo ]
}

resource "aws_instance" "k8s_worker" {
  ami = lookup(var.ec2_instances, "ami")
  instance_type = lookup(var.ec2_instances, "itype")
  subnet_id = aws_subnet.k8s_subnet.id #FFXsubnet2
  associate_public_ip_address = lookup(var.ec2_instances, "publicip")
  # count = lookup(var.ec2_instances, "instance_count")

  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.name

  key_name = "${aws_key_pair.terraform-demo.key_name}"

  vpc_security_group_ids = [ aws_security_group.k8s-worker.id ]

  tags = {
    # Name = "k8s-ec2-${count.index + 1}"
    Name = "k8s-worker"
    Managed = "IAC"
  }
  
  depends_on = [ aws_security_group.k8s-worker, aws_key_pair.terraform-demo ]
}

resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("${var.public_key_path}")}"

  tags = {
      Name = "k8s-keypair-${var.environment}"
      Managed = "IAC"
  }
}

# resource "aws_security_group" "k8s-sg" {
#   name = lookup(var.ec2_instances, "secgroupname")
#   description = lookup(var.ec2_instances, "secgroupname")
#   vpc_id = lookup(var.ec2_instances, "vpc")

#   // To Allow SSH Transport
#   ingress {
#     from_port = 22
#     protocol = "tcp"
#     to_port = 22
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   // To Allow Port 80 Transport
#   ingress {
#     from_port = 80
#     protocol = "tcp"
#     to_port = 80
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  # egress {
  #   from_port       = 0
  #   to_port         = 0
  #   protocol        = "-1"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#       Name = "k8s-publicip-${var.environment}"
#       Managed = "IAC"
#   }
# }