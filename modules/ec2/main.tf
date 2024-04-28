resource "aws_instance" "example" {
  count         = length(var.ec2_instances)
  subnet_id     = var.ec2_instances[count.index].subnet_id
  instance_type = var.ec2_instances[count.index].instance_type
  ami = local.ami
  availability_zone = var.availability_zone
  # iam_instance_profile = module.iam.iam_instance_profile.
  key_name = local.key_name
  root_block_device {
    volume_size = var.ec2_instances[count.index].volume_size
    volume_type = "gp3"
  }
  network_interface {
    network_interface_id = aws_network_interface.example[count.index].id
    device_index = 0
  }
  tags = {
    "Name" = var.ec2_instances[count.index].name
  }
}

resource "aws_network_interface" "example" {
  count          = length(var.ec2_instances)
  subnet_id      = var.ec2_instances[count.index].subnet_id
  private_ips    = [var.ec2_instances[count.index].private_ip]
  security_groups = [aws_security_group.example.id]
  # source_dest_check =
}

resource "aws_security_group" "example" {
  // Define your security group rules here
  // You may want to allow ingress traffic from specific sources and ports
}