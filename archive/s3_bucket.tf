resource "aws_s3_bucket" "artifact_storage" {
  bucket = "foundation-pipeline-bucket"
  object_lock_enabled = false
  tags = {
    Name = "Artifact Storage"
  }
}

resource "aws_s3_bucket_versioning" "status" {
  bucket = aws_s3_bucket.artifact_storage.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "allow_all" {
  bucket = aws_s3_bucket.artifact_storage.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          "AWS" = [
            "arn:aws:iam::<>:role/<>",
            "arn:aws:iam::<>:user/<>",
            "${aws_iam_role.runner.arn}"
          ]
        }
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
