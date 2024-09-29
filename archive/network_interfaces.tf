resource "aws_network_interface" "gitlab" {
  subnet_id = aws_subnet.private.id
  private_ips = ["10.30.1.100"]
  security_groups = [aws_security_group.gitlab.id]
  tags = {
    Name = "GitLab Server"
  }
}

resource "aws_network_interface" "primary_runner" {
  subnet_id = aws_subnet.private.id
  private_ips = ["10.30.1.101"]
  security_groups = [aws_security_group.gitlab.id]
  tags = {
    Name = "Primary GitLab runner"
  }
}

resource "aws_network_interface" "secondary_runner" {
  subnet_id = aws_subnet.private.id
  private_ips = ["10.30.1.102"]
  security_groups = [aws_security_group.gitlab.id]
  tags = {
    Name = "Secondary GitLab runner"
  }
}

resource "aws_network_interface" "tertiary_runner" {
  subnet_id = aws_subnet.private.id
  private_ips = ["10.30.1.103"]
  security_groups = [aws_security_group.gitlab.id]
  tags = {
    Name = "Tertiary GitLab runner"
  }
}

resource "aws_network_interface" "openvpn" {
  subnet_id = aws_subnet.public.id
  private_ips = ["10.30.2.10"]
  security_groups = [aws_security_group.vpn.id]
  source_dest_check = false
  tags = {
    Name = "OpenVPN Proxy"
  }
}

resource "aws_network_interface" "openvpn_backup" {
  subnet_id = aws_subnet.public.id
  private_ips = ["10.30.2.11"]
  security_groups = [aws_security_group.vpn.id]
  source_dest_check = false
  tags = {
    Name = "Backup OpenVPN Proxy"
  }
}