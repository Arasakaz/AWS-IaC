// packer {
//     required_plugins {
//         amazon = {
//             version = ">=1.2.8"
//             source = "github.com/hashicorp/amazon"
//         }
//     }
// }

source "amazon-ebs" "ubuntu" {
    ami_name = "grads-awscli-installed"
    instance_type = "t2.micro"
    region = "eu-west-2"
    // source_ami_filter {
    //     filters = {
    //         name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    //         root-device-type = "ebs"
    //         virtualization-type = "hvm"
    //     }
    //     most_recent = true
    //     owners = ["099720109477"]
    // }
    source_ami = "ami-0b9932f4918a00c4f"
    ssh_username = "ubuntu"
    vpc_id = "vpc-06d810240d8e34537"
    subnet_id = "subnet-085ae2fe224003adb"
    security_group_id = "sg-00c9f8f0359bb2fe1"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Zip",
      "sudo apt-get update",
      "sudo apt-get install unzip",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
    ]
  }
}
