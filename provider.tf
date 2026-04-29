provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-south-1"
}