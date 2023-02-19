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