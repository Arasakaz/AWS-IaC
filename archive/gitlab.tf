resource "aws_instance" "gitlab" {
  ami = var.ami_id.ubuntu_old
  instance_type = var.instance_type.gitlab
  availability_zone = var.availability_zone
  key_name = ""
  iam_instance_profile = aws_iam_instance_profile.gitlab.name
  root_block_device {
    volume_size = 500
    tags = {
      Name = "GitLab server"
    }
  }
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.gitlab.id
  }
  tags = {
    Name = "GitLab server"
  }
}

resource "aws_instance" "primary_runner" {
  ami = var.ami_id.ubuntu_2404
  instance_type = var.instance_type.runner
  availability_zone = var.availability_zone
  key_name = ""
  iam_instance_profile = aws_iam_instance_profile.runner.name
  root_block_device {
    volume_size = 25
    tags = {
      Name = "Primary GitLab runner"
    }
  }
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.primary_runner.id
  }
  tags = {
    Name = "Primary GitLab runner"
  }
}
resource "aws_ec2_instance_state" "primary_runner" {
  instance_id = aws_instance.primary_runner.id
  state = "running"
}

resource "aws_instance" "secondary_runner" {
  ami = var.ami_id.ubuntu_2404
  instance_type = var.instance_type.runner
  availability_zone = var.availability_zone
  key_name = ""
  iam_instance_profile = aws_iam_instance_profile.runner.name
  root_block_device {
    volume_size = 25
    tags = {
      Name = "Secondary GitLab runner"
    }
  }
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.secondary_runner.id
  }
  tags = {
    Name = "Secondary GitLab runner"
  }
}
resource "aws_ec2_instance_state" "secondary_runner" {
  instance_id = aws_instance.secondary_runner.id
  state = "running"
}

resource "aws_instance" "tertiary_runner" {
  ami = var.ami_id.ubuntu_2404
  instance_type = var.instance_type.runner
  availability_zone = var.availability_zone
  key_name = ""
  iam_instance_profile = aws_iam_instance_profile.runner.name
  root_block_device {
    volume_size = 25
    tags = {
      Name = "Tertiary GitLab runner"
    }
  }
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.tertiary_runner.id
  }
  tags = {
    Name = "Tertiary GitLab runner"
  }
}
resource "aws_ec2_instance_state" "tertiary_runner" {
  instance_id = aws_instance.tertiary_runner.id
  state = "running"
}