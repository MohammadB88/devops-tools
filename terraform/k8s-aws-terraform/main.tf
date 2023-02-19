module "resources" {
  source = "./resources/iam"
}

module "ec2-controlplane" {
  source = "./resources/ec2"
}