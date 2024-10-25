resource "aws_iam_role" "rds_to_s3_backup_lambda" {
  name = "${local.environment}-${local.namespace}-rds-to-s3-backup-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  inline_policy {
    name = "api-inline-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:PutObject"
          ],
          Effect   = "Allow",
          Resource = "*"
          Sid      = "AllowPutObjectOnS3",
        }
      ]
    })
  }
}
resource "aws_iam_policy" "ecr_read_only_access" {
  name = "${local.environment}-${local.namespace}-ECRReadOnlyAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaECRImageRetrievalPolicy"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "vpc_access_for_lambda" {
  role       = aws_iam_role.rds_to_s3_backup_lambda.name
  policy_arn = data.aws_iam_policy.AWS_lambda_VPC_access_execution_role.arn
}
resource "aws_iam_role_policy_attachment" "basic_execution_access_for_lambda" {
  role       = aws_iam_role.rds_to_s3_backup_lambda.name
  policy_arn = data.aws_iam_policy.aws_lambda_basic_execution_role.arn
}
resource "aws_iam_role_policy_attachment" "ecr_read_only_access_for_lambda" {
  role       = aws_iam_role.rds_to_s3_backup_lambda.name
  policy_arn = aws_iam_policy.ecr_read_only_access.arn
}
