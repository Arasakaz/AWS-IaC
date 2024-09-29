packer {
    required_plugins {
        amazon = {
            version = ">=1.2.8"
            source = "github.com/hashicorp/amazon"
        }
    }
}

packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "rhel-nexus" {
    ami_name = "nexus-server"
    instance_type = "m6a.2xlarge"
    region= "eu-west-2"
    source_ami = "ami-035cecbff25e0d91e"
    ssh_username = "ec2-user"
    vpc_id = "vpc-06d810240d8e34537"
    subnet_id = "subnet-085ae2fe224003adb"
    security_group_id = "sg-00c9f8f0359bb2fe1"
    
    launch_block_device_mappings {
        device_name = "/dev/sda1"
        volume_size = 120
    }
}

build {
    sources = [
        "souce.amazon-ebs.rhel-nexus"
    ]

    // provisioner "shell" {
    //     inline = [
    //         // "echo Installing Zip",
    //         // "sudo yum update -y",
    //         // "sudo yum install wget zip unzip -y",
    //         // "sudo yum install java-11-openjdk -y",
    //         // "cd /opt",
    //         // "sudo wget https://download.sonatype.com/nexus/3/nexus-3.67.0-03-java11-unix.tar.gz",
    //         // "sudo tar xvzf nexus-3.67.0-03-java11-unix.tar.gz",
    //         // "sudo useradd -s /usr/sbin/nologin -r -M nexus",
    //         // "sudo ln - s nexus-3.67.0-03 nexus",
    //         "which gtar",
    //         "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+DFhD+HWwemeh6P68odNXJtN6rOYBrGmaeHnIp6JX3 william.rhodes102@mod.gov.uk' > ~/.ssh/authorized_keys"
    //     ]
    // }

    provisioner "ansible" {
        playbook_file = "./ansible/playbooks/install_nexus.yml"
        # playbook_file = "./install_nexus_new.yml"
    }

}
