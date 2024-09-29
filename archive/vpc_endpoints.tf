#################### S3 Bucket ####################
resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.eu-west-2.s3"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "S3 Gateway"
  }
}
resource "aws_vpc_endpoint_policy" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Access-to-specific-bucket-only"
        Principal = "*"
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          "${aws_s3_bucket.artifact_storage.arn}",
          "${aws_s3_bucket.artifact_storage.arn}/*"
        ]
      }
    ]
  })
}
resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_endpoint_type = "Interface"
  service_name = "com.amazonaws.eu-west-2.ec2"
  private_dns_enabled = true
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "EC2 Privatelink"
  }
}


#################### EC2 ####################
resource "aws_vpc_endpoint_policy" "ec2" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Effect = "Allow"
        Action = "ec2:*"
        Resource = "*"
      }
    ]
  })
}
resource "aws_vpc_endpoint_subnet_association" "ec2" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  subnet_id = aws_subnet.private.id
}
resource "aws_vpc_endpoint_security_group_association" "ec2" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  security_group_id = aws_security_group.endpoints.id
}


#################### STS ####################
resource "aws_vpc_endpoint" "sts" {
  vpc_endpoint_type = "Interface"
  service_name = "com.amazonaws.eu-west-2.sts"
  private_dns_enabled = true
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "STS Privatelink"
  }
}
resource "aws_vpc_endpoint_policy" "sts" {
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Effect = "Allow"
        Action = "sts:*"
        Resource = "*"
      }
    ]
  })
}
resource "aws_vpc_endpoint_subnet_association" "sts" {
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  subnet_id = aws_subnet.private.id
}
resource "aws_vpc_endpoint_security_group_association" "sts" {
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  security_group_id = aws_security_group.endpoints.id
}


#################### KMS ####################
resource "aws_vpc_endpoint" "kms" {
  vpc_endpoint_type = "Interface"
  service_name = "com.amazonaws.eu-west-2.kms"
  private_dns_enabled = true
  vpc_id = aws_vpc.main.id
  tags = {
    Name =  "KMS Privatelink"
  }
}

resource "aws_vpc_endpoint_policy" "kms" {
  vpc_endpoint_id = aws_vpc_endpoint.kms.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Effect = "Allow"
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_vpc_endpoint_subnet_association" "kms" {
  vpc_endpoint_id = aws_vpc_endpoint.kms.id
  subnet_id = aws_subnet.private.id
}

resource "aws_vpc_endpoint_security_group_association" "kms" {
  vpc_endpoint_id = aws_vpc_endpoint.kms.id
  security_group_id = aws_security_group.endpoints.id
}

#################### EBS ####################
resource "aws_vpc_endpoint" "ebs" {
  vpc_endpoint_type = "Interface"
  service_name = "com.amazonaws.eu-west-2.ebs"
  private_dns_enabled = true
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "EBS Privatelink"
  }
}

resource "aws_vpc_endpoint_subnet_association" "ebs" {
  vpc_endpoint_id = aws_vpc_endpoint.ebs.id
  subnet_id = aws_subnet.private.id
}

resource "aws_vpc_endpoint_security_group_association" "ebs" {
  vpc_endpoint_id = aws_vpc_endpoint.ebs.id
  security_group_id = aws_security_group.endpoints.id
}