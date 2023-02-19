variable "awsprops" {
    type = map
    default = {
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
