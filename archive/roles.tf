resource "aws_iam_role" "runner" {
  name = "runnerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  tags = {
    Name = "GitLab Runner"
  }
}

resource "aws_iam_instance_profile" "runner" {
  name = "runner"
  role = aws_iam_role.runner.name
}

resource "aws_iam_role" "gitlab" {
  name = "gitlabRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  tags = {
    Name = "GitLab"
  }
}
resource "aws_iam_instance_profile" "gitlab" {
  name = "gitlab"
  role = aws_iam_role.gitlab.name
}

resource "aws_iam_policy_attachment" "s3" {
  name       = "s3_attachment"
  roles      = [aws_iam_role.runner.name, aws_iam_role.gitlab.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "vpc" {
  name = "vpc_attachmnt"
  roles = [aws_iam_role.gitlab.name, aws_iam_role.runner.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_policy_attachment" "ec2" {
  name = " ec2_attachment"
  roles = [aws_iam_role.gitlab.name, aws_iam_role.runner.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "iam" {
  name = "iam_attachment"
  roles = [aws_iam_role.gitlab.name, aws_iam_role.runner.name]
  policy_arn  = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_policy_attachment" "kms" {
  name = "kms_attachment"
  roles = [aws_iam_role.gitlab.name, aws_iam_role.runner.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}

resource "aws_iam_policy" "kms_allow_all" {
  name = "kms_allow_all"
  # policy = jsondecode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Action = [
  #         "kms:*",
  #       ]
  #       Effect = "Allow",
  #       Resource = "*"
  #     },
  #   ]
  # })
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "kms_all_attachment" {
  name = "kms_all_attachment"
  roles = [aws_iam_role.runner.name]
  policy_arn = aws_iam_policy.kms_allow_all.arn
}