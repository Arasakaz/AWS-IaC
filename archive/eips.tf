resource "aws_eip" "openvpn" {
  domain = "vpc"
  instance = aws_instance.openvpn_proxy.id
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "OpenVPN Proxy"
  }
}

resource "aws_eip" "openvpn_backup" {
  domain = "vpc"
  network_interface = aws_network_interface.openvpn_backup.id
  tags = {
    Name = "OpenVPN Proxy Backup"
  }
}

# resource "aws_eip" "runnerDev_eip" {
#   domain = "vpc"
#   instance = aws_instance.runner-dev.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }

# resource "aws_eip" "runnerTest_eip" {
#   domain = "vpc"
#   instance = aws_instance.runner-test.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }

# resource "aws_eip" "runnerProd_eip" {
#   domain = "vpc"
#   instance = aws_instance.runner-prod.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }

# resource "aws_eip" "dev_eip" {
#   domain = "vpc"
#   instance = aws_instance.dev.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }

# resource "aws_eip" "test_eip" {
#   domain = "vpc"
#   instance = aws_instance.test.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }

# resource "aws_eip" "prod_eip" {
#   domain = "vpc"
#   instance = aws_instance.prod.id

#   depends_on = [ aws_internet_gateway.gateway ]
# }