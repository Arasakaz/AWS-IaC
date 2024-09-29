variable "ami_id" {
  type = map(string)
  default = {
    ubuntu_old = "ami-0505148b3591e4c07"
    ubuntu_2404 = "ami-053a617c6207ecc7b"
  }
}

variable "instance_type" {
  type = map(string)
  default = {
    runner = "t3a.medium"
    gitlab = "m6a.large"
  }
}

variable "availability_zone" {
  type = string
  default = "eu-west-2a"
}