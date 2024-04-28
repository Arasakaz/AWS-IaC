variable "availability_zone" {}
locals {
  ami = "ami-"
  key_name = "master_key"
  instance_type = {
    gitlab = "m6a.large"
    openvpn = "t3a.micro"
    runner = "t3a.medium"
  }
}

variable "ec2_instances" {
  type = list(object({
    name          = string
    instance_type = string
    private_ip    = string
    subnet_id     = string
    volume_size   = number
  }))
  default = [
    {
      name          = "GitLab repository"
      instance_type = local.instance_type.gitlab
      private_ip    = "10.0.1.100"
      subnet_id     = module.vpc.private_subnet_id
      volume_size   = 100
    },
    {
      name          = "GitLab runner 1"
      instance_type = local.instance_type.runner
      private_ip    = "10.0.1.101"
      subnet_id     = module.vpc.private_subnet_id
      volume_size   = 20
    },
    {
      name          = "GitLab runner 2"
      instance_type = local.instance_type.runner
      private_ip    = "10.0.1.102"
      subnet_id     = module.vpc.private_subnet_id
      volume_size   = 20
    },
    {
      name          = "GitLab runner 3"
      instance_type = local.instance_type.runner
      private_ip    = "10.0.1.103"
      subnet_id     = module.vpc.private_subnet_id
      volume_size   = 20
    },
    {
      name          = "OpenVPN server"
      instance_type = local.instance_type.openvpn
      private_ip    = "10.0.2.10"
      subnet_id     = module.vpc.public_subnet_id
      volume_size   = 8
    },
  ]
}
