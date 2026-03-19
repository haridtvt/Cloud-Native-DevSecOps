resource "aws_s3_bucket" "security_reports" {
  bucket = "devsecops-reports-haridtvt"
  force_destroy = true
  tags = {
    Name = "S3_DevSecOps",
    terraform = "true"
  }
}
resource "aws_s3_bucket_public_access_block" "reports_block" {
  bucket = aws_s3_bucket.security_reports.id
  block_public_acls   = true
  block_public_policy  = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "s3_upload_policy" {
  name        = "SecurityReportsUploadPolicy"
  tags = {
    Name = "IAM_policies_DevSecOps",
    terraform = "true"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject"]
        Effect  = "Allow"
        Resource = "${aws_s3_bucket.security_reports.arn}/*"
      }
    ]
  })
}