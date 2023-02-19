# Variables that are used in the resource creation module will be put here.
variable "iam_role_name" {
  type = string
  default = "K8sIamRole"
}

variable "instance_profile_name" {
  type    = string
  default = "K8sInstanceProfile"
}

variable "environment" {
  type = string
  default = "TEST"
}

variable "ec2_instances" {
    type = map
    default = {
    instance_count = 2
    prefix = "k8s_server"
    region = "eu-central-1"
    vpc = "vpc-024868b339a6580c4"
    ami = "ami-0c0d3776ef525d5dd"
    itype = "t2.micro"
    subnet = "subnet-0a421c7ba75aef2fd"
    publicip = true
    secgroupname = "IAC-Sec-Group"
  }
}

variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/terraform-demo.pub"
  sensitive = true
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/terraform-demo"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ec2-user"
}