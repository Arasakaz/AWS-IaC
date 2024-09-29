############################################################
####                         VPN                        ####
############################################################
resource "aws_security_group" "vpn" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPN rules group"
  }
}
resource "aws_vpc_security_group_ingress_rule" "listener" {
  description = "UDP Port on which OpenVPN listens for incoming connections"
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 1194
  to_port = 1194
  ip_protocol = "udp"
  tags = {
    Name = "OpenVPN UDP listener"
  }
}
#---------------------------
# SSH
resource "aws_vpc_security_group_ingress_rule" "ssh_vpn-vpn" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = "10.8.0.0/24"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from VPN subnet into VPN box"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ssh_priv-vpn" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = aws_subnet.private.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "Runners SSH into VPN box"
  }
}
# resource "aws_vpc_security_group_ingress_rule" "ssh_awsclient-vpn" {
#   security_group_id = aws_security_group.vpn.id
#   cidr_ipv4 = "172.31.0.0/22"
#   ip_protocol = "tcp"
#   from_port = 22
#   to_port = 22
#   tags = {
#     Name = "SSH from AWS client into VPN box"
#   }
# }
resource "aws_vpc_security_group_egress_rule" "ssh_vpn-priv" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = aws_subnet.private.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH into private subnet"
  }
}
resource "aws_vpc_security_group_egress_rule" "ssh_vpn-sandbox" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = "10.40.0.0/26"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from VPN into sandbox"
  }
}
#---------------------------
# HTTP
resource "aws_vpc_security_group_egress_rule" "http_vpn-sandbox" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = "10.40.0.0/26"
  ip_protocol = "tcp"
  from_port = 8081
  to_port = 8081
  tags = {
    Name = "HTTP from VPN into sandbox"
  }
}
#---------------------------
# HTTPS
resource "aws_vpc_security_group_egress_rule" "https_vpn-priv" {
  security_group_id = aws_security_group.vpn.id
  cidr_ipv4 = aws_subnet.private.cidr_block
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  tags = {
    Name = "HTTPS from VPN into private subnet"
  }
}


############################################################
####                       GitLab                       ####
############################################################
resource "aws_security_group" "gitlab" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "GitLab rules group"
  }
}
#---------------------------
# SSH
resource "aws_vpc_security_group_ingress_rule" "ssh_vpn-priv" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = "10.8.0.0/24"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from VPN subnet into private subnet"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ssh_pub-priv" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = aws_subnet.public.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from public subnet into private subnet"
  }
}

resource "aws_vpc_security_group_egress_rule" "ssh_priv-pub" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = aws_subnet.public.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from private subnet into public subnet"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_priv-internal" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = aws_subnet.private.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH private subnet internally"
  }
}

resource "aws_vpc_security_group_egress_rule" "ssh_internal-priv" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = aws_subnet.private.cidr_block
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH private subnet internally egress"
  }
}

# resource "aws_vpc_security_group_ingress_rule" "ssh_awsclient-priv" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = "172.31.0.0/22"
#   ip_protocol = "tcp"
#   from_port = 22
#   to_port = 22
#   tags = {
#     Name = "SSH from AWS client vpn into private subnet"
#   }
# }
resource "aws_vpc_security_group_egress_rule" "ssh_priv-sandbox" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = "10.40.0.0/26"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  tags = {
    Name = "SSH from private subnet into sandbox"
  }
}
#---------------------------
# HTTPS
# resource "aws_vpc_security_group_ingress_rule" "https_priv-internal" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.private.cidr_block
#   ip_protocol = "tcp"
#   from_port = 443
#   to_port = 443
#   tags = {
#     Name = "HTTPS private subnet internally"
#   }
# }
resource "aws_vpc_security_group_ingress_rule" "https_anywhere-priv" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  tags = {
    Name = "HTTPS to private subnet internally"
  }
}
# resource "aws_vpc_security_group_ingress_rule" "https_vpn-priv" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.public.cidr_block
#   ip_protocol = "tcp"
#   from_port = 443
#   to_port = 443
#   tags = {
#     Name = "HTTPS from public subnet into private subnet"
#   }
# }
# resource "aws_vpc_security_group_egress_rule" "https_priv-endpoint" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.private.cidr_block
#   ip_protocol = "tcp"
#   from_port = 443
#   to_port = 443
#   tags = {
#     Name = "HTTPS from private subnet to vpc endpoints"
#   }
# }
resource "aws_vpc_security_group_egress_rule" "https_priv-anywhere" {
  security_group_id = aws_security_group.gitlab.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  tags = {
    Name = "HTTPS in private subnet"
  }
}

# resource "aws_vpc_security_group_ingress_rule" "http_monitoring-priv" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.private.cidr_block
#   ip_protocol = "tcp"
#   from_port = 9090
#   to_port = 9600
#   tags = {
#     Name = "HTTP for monitoring"
#   }
# }

# resource "aws_vpc_security_group_egress_rule" "http_priv-monitoring" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.private.cidr_block
#   ip_protocol = "tcp"
#   from_port = 9090
#   to_port = 9600
#   tags = {
#     Name = "HTTP for monitoring2"
#   }
# }
# resource "aws_vpc_security_group_egress_rule" "https_priv-pub" {
#   security_group_id = aws_security_group.gitlab.id
#   cidr_ipv4 = aws_subnet.public.cidr_block
#   ip_protocol = "tcp"
#   from_port = 443
#   to_port = 443
#   tags = {
#     Name = "HTTPS from private subnet to public subnet"
#   }
# }

############################################################
####                    VPC Endpoints                   ####
############################################################
resource "aws_security_group" "endpoints" {
  description = "Allow all from anywhere for AWS services"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPC Endpoints rules group"
  }
}
resource "aws_vpc_security_group_ingress_rule" "https_priv-aws" {
  security_group_id = aws_security_group.endpoints.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  tags = {
    Name = "HTTPS from private subnet to endpoints"
  }
}
resource "aws_vpc_security_group_egress_rule" "https_aws-priv" {
  security_group_id = aws_security_group.endpoints.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  tags = {
    Name = "HTTPS from endpoints to private subnet or AWS"
  }
}

############################################################
####          TESTING PURPOSES - DO NOT USE!            ####
############################################################
resource "aws_security_group" "tester" {
  name = "TESTER"
  description = "Allow all traffic"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "TESTER"
  }
}
resource "aws_vpc_security_group_ingress_rule" "all" {
  security_group_id = aws_security_group.tester.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.tester.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}