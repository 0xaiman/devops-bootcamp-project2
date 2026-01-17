resource "aws_iam_role" "ssm" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}



resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  role = aws_iam_role.ssm.name
}

# Allow EC2 instances with this role to read from the bootstrap S3 bucket
resource "aws_iam_role_policy" "ssm_s3_readonly" {
  name = "ec2-ssm-s3-readonly"
  role = aws_iam_role.ssm.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
        ]
        Resource = [
          aws_s3_bucket.bootstrap_bucket.arn,
          "${aws_s3_bucket.bootstrap_bucket.arn}/*"
        ]
      }
    ]
  })
}
