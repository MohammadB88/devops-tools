provider "aws" {
  profile    = "default"
  region     = lookup(var.awsprops, "region")
}