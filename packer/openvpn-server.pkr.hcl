source "amazon-ebs" "openvpn-server" {
    ami_name = "openvpn-server"
    instance_type = "t3a.small"
    region = "eu-west-2"
    source_ami = "ami-035cecbff25e0d91e"
    ssh_username = "ec2-user"
    vpc_id = "vpc-06d810240d8e34537"
    subnet_id = "subnet-067ff1847ad41e87f"
    security_group_id = "sg-09331e9695846c640" #sg-0403adc3e4c023b3b" # Default security group
    associate_public_ip_address = true

    launch_block_device_mappings {
        device_name = "/dev/sda1"
        volume_size = 10
    }
}

build {
    sources = [
        "source.amazon-ebs.openvpn-server"
    ]

    // provisioner "ansible" {
    //     playbook_file ="./ansible/playbooks/install_openvpn.yml"
    // }

    provisioner "shell" {
        environment_vars = [
            "AUTO_INSTALL=y",
            "APPROVE_IP=y",
            "IPV6_SUPPORT=n",
            "PORT_CHOICE=1",
            "PROTOCOL_CHOICE=1",
            "DNS=1",
            "COMPRESSION_ENABLED=n"
        ]
        script = "./bash/scripts_folder/install_openvpn.sh"
        execute_command = "echo '' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    }
}