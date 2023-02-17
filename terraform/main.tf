resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = "${aws_key_pair.terraform-demo.key_name}"

  vpc_security_group_ids = [ aws_security_group.project-iac-sg.id ]

  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.project-iac.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.project-iac.public_ip}, --private-key ${var.private_key_path} simple_webapp.yml"
    working_dir = "../ansible"

    environment = {
      TF_LOG_PATH = "output.txt"
    }
  }

  depends_on = [ aws_security_group.project-iac-sg, aws_key_pair.terraform-demo ]
}

resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("${var.public_key_path}")}"
}

resource "aws_security_group" "project-iac-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "local_file" "ip" {
#     depends_on = [ aws_instance.project-iac ]
#     content  = "[webserver] \n${aws_instance.project-iac.public_ip}"
#     filename = "../ansible/Inventory"
# }

# resource "null_resource" "nulllocal1" {
#   # depends_on = [ local_file.ip ]
#   provisioner "local-exec" {
#     # command = "touch ansible_output.txt & echo $(whoami) >> ansible_output.txt" 
#     command = "ansible-playbook -i 18.185.188.155 --private-key ${var.private_key_path} ../ansible/simple_webapp.yml > ansible_output.txt"
#     # interpreter = ["bash", "-c"]
#     working_dir = "../ansible"

#     environment = {
#       FOO = "bar"
#       BAR = 1
#       BAZ = "true"
#       TF_LOG_PATH = "../ansible/output.txt"
#     }
#   }
# }

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}

# provisioner "local-exec" {
#   command = "chrome http://${aws_instance.project-iac.public_ip}/web/"
# }